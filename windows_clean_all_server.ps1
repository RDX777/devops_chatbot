# Install-Module -Name Posh-SSH -Force -AllowClobber

Import-Module Posh-SSH

$listServers = @(
    [PSCustomObject]@{
        name = "TBT05-PLN-CT"
        ip = "10.3.60.10"
        userName = "root"
        password = "Zaq12wsx"
        reboot = $true
        docker = @(
            [PSCustomObject]@{
                file = "/docker/redis/docker-compose.yml"
                extra = $null
            },
            [PSCustomObject]@{
                file = "/docker/redis-php-admin/docker-compose.yml"
                extra = $null
            }             
        )
    },
    [PSCustomObject]@{
        name = "TBT05-PLN-CT"
        ip = "10.3.60.9"
        userName = "root"
        password = "Zaq12wsx"
        reboot = $true
        docker = @(
            [PSCustomObject]@{
                file = "/docker/postgres/docker-compose.yml"
                extra = "exec psql -U postgres -c 'CREATE DATABASE n8n;'"
            },
            [PSCustomObject]@{
                file = "/docker/adminer/docker-compose.yml"
                extra = $null
            
            }             
        )
    },
    [PSCustomObject]@{
        name = "TBT04-PLN-CT"
        ip = "10.3.60.8"
        userName = "root"
        password = "Zaq12wsx"
        reboot = $true
        docker = @(
            [PSCustomObject]@{
                file = "/docker/mongodb/docker-compose.yml"
                extra = $null
            },
            [PSCustomObject]@{
                file = "/docker/mongo-express/docker-compose.yml"
                extra = $null
            }             
        )
    },
    [PSCustomObject]@{
        name = "TBT02-PLN-CT"
        ip = "10.3.60.6"
        userName = "root"
        password = "Zaq12wsx"
        reboot = $true
        docker = @(
            [PSCustomObject]@{
                file = "/docker/nginx_http/docker-compose.yml"
                extra = $null
            }          
        )
    },
    [PSCustomObject]@{
        name = "TBT01-PLN-CT"
        ip = "10.3.60.5"
        userName = "root"
        password = "Zaq12wsx"
        reboot = $false
        docker = @(
            [PSCustomObject]@{
                file = "/docker/evolution-api/docker-compose.yml"
                extra = $null
            },
            [PSCustomObject]@{
                file = "/docker/chatwoot/docker-compose.yml"
                extra = "run --rm rails bundle exec rails db:chatwoot_prepare"
            },
            [PSCustomObject]@{
                file = "/docker/typebot.io/docker-compose.yml"
                extra = $null
            },
            [PSCustomObject]@{
                file = "/docker/n8n/docker-compose.yml"
                extra = $null
            }
        )
    }
)

function Start-FlushDocker{
    Param (
        [System.Object] $server
    )

    $command = "plink -ssh $($server.userName)@$($server.ip) -P 22 -pw $($server.password) -batch -m .\flush_all_docker.sh"

    Invoke-Expression -Command $command
}

function Install-AllImages{
        Param (
        [System.Object] $server
    )

    for ($i = 0; $i -lt $server.docker.length; $i++) {
        $docker = $server.docker[$i]
        Invoke-Expression "plink -ssh $($server.userName)@$($server.ip) -P 22 -pw $($server.password) -batch docker-compose -f $($docker.file) up -d --build"
        if($docker.extra) {
            Invoke-Expression "plink -ssh $($server.userName)@$($server.ip) -P 22 -pw $($server.password) -batch docker-compose -f $($docker.file) $($docker.extra)"
        }
    
    }

    if($server.reboot) {
        Invoke-Expression "plink -ssh $($server.userName)@$($server.ip) -P 22 -pw $($server.password) -batch reboot"
    }
}

function Run-CreateUserChatwoot{
    https://app.chatwoot.com/platform/api/v1/users
}

function Run-CreateInstanceEvolution{
    $url = "http://10.3.60.6:7084/instance/create"
    $apiKey = "AB2E8F9C7D5B3A1F6E4D2C8D5A9C4F3E2"
    $body = @{
        instanceName = "suporte_ti"
        token = "3EF39FC7-DA4B-4ABD-8A27-69C107AF0945"
        qrcode = $true
		sign_msg = $true
        chatwoot_account_id = 1
        chatwoot_token = "Seu token aqui"
        chatwoot_url = "http://10.3.60.6:7083"
        chatwoot_sign_msg = $true
		chatwoot_reopen_conversation = $true
		chatwoot_conversation_pending = $true
    }
    $bodyJson = $body | ConvertTo-Json
    $headers = @{
        "apikey" = $apiKey
    }

    $response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
    Write-Host $response
}

function Run-Main{
    for ($i = 0; $i -lt $listServers.length; $i++) {
        $server = $listServers[$i]
        Start-FlushDocker $server
        Install-AllImages $server
    }
    Run-CreateInstanceEvolution
}

Run-Main
