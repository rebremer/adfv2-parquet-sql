import logging

import azure.functions as func
from msrestazure.azure_active_directory import MSIAuthentication
from azure.storage.blob import (
    BlockBlobService,
    BlobPermissions,
    ContainerPermissions
)
from azure.storage.common import (
    TokenCredential
)

from datetime import datetime


def main(msg: func.QueueMessage) -> None:
    logging.info('Python queue trigger function processed a queue item: %s',
                 msg.get_body().decode('utf-8'))

    # get bearer token and authenticate to ADLSgen2 using Managed Identity of Azure Function
    credentials = MSIAuthentication(resource='https://storage.azure.com/')
    blob_service = BlockBlobService("testedlstorgen", token_credential=credentials)

    # get timestamp
    now = datetime.now()
    nowstr = datetime.strftime(datetime.now(), "%Y%m%dT%H%M%S%Z")
    key=round((now-datetime(2019,1,1,0,0,0)).total_seconds())
    logging.info("key: " + str(key))

    # Add record to csv file. Notice that AppendBlob is not yet supported on ADLSgen2, see https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-known-issues
    records = blob_service.get_blob_to_text("raw", "testprivcmddataflow/WideWorldImporters-Sales/address/SalesLTAddress.txt").content
    records += "\n" + str(key) + ",8713 Yosemite Ct.,,Bothell,Washington,United States,98011,268af621-76d7-4c78-9441-144fd139821a,2006-07-01 00:00:00.0000000"
    blob_service.create_blob_from_text("raw", "testprivcmddataflow/WideWorldImporters-Sales/address/SalesLTAddress.txt", records)

    # Create event such that ADFv2 is triggered
    blob_service = BlockBlobService("testedlstorgen", token_credential=credentials)
    blob_service.create_blob_from_text("adftrigger", "adftrigger" + nowstr + ".txt", "")