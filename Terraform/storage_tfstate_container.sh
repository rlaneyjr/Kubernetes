#!/usr/bin/env sh

az storage container create -n tfstate --account-name "rlstore01" --account-key "i59xNBEYslSWCCZ+3o+LBvXoWICnJE37o4AmJrq3Yogq33oFhTqRljSqREZcAKyklU+4d4alfzRvthZ5XmI0JQ=="

terraform init -backend-config="storage_account_name=rlstore01" -backend-config="container_name=tfstate" -backend-config="access_key=i59xNBEYslSWCCZ+3o+LBvXoWICnJE37o4AmJrq3Yogq33oFhTqRljSqREZcAKyklU+4d4alfzRvthZ5XmI0JQ==" -backend-config="key=codelab.microsoft.tfstate"
