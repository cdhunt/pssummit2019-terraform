param(
    [parameter(mandatory)]
    [hashtable]$Parameters
)

describe 'terraform-module-storage' {
    BeforeAll {
        $rgName             = "tf_$($Parameters.tf_var_prefix)"
        $storageAccountName = $Parameters.tf_var_prefix + 'stdstorage'
        $storage            = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $rgName
    }

    context 'Configuration' {
        it "Storage account name is [$storageAccountName]" {
            $storage.StorageAccountName | should -be $storageAccountName
        }

        it "Azure region is [$($Parameters.tf_var_location)]" {
            $storage.Location | should -be $Parameters.tf_var_location
        }

        it 'Access tier is [Standard]' {
            $storage.Sku.Tier | should -be 'Standard'
        }
    }
}