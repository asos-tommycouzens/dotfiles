# source: https://gist.github.com/asos-tommycouzens/86758dc5f532f22766be4bd86963eedf

# TODO: Add section up here on usage

# Description: Used to for setting your namespace so you don't need to do --namespace in every command
# Usage: kns plp-webft1
kns() {
  kubectl config set-context --current --namespace=$1
}

klogin() {
    if [ "$#" -lt 2 ]; then
        echo "Input the cluster region and number e.g: klogin euw 06"
        echo "Check available clusters with: kinfo"
        return 0
    fi

  # Set vars
  region=$1
  num=$2
  env=${3:-np}
  if [ "$env" = "pd" ]; then sub="2896e29c-5128-42e3-a50b-e13e7d47a59e"; else sub="b97b4ae3-ccc5-46d9-9739-831517bfd51c"; fi

  # Do stuff
  echo "env: $env"
  az account set --subscription $sub
  sleep 1
  if ! az aks get-credentials --resource-group as-$env-$region-web-$num-aks-rg --name as-$env-$region-web-$num-aks; then
    echo -n "\nCheck available clusters with: kinfo"
    echo "The keyword for production clusters is 'pd'"
  fi
}

# Description: Use to switch your kube context between kubernetes clusters
# Usage: kctx <region> <number>
# Usage: kctx eun 06
# Usage prod: kctx eun 06 pd
kctx() {
    if [ "$#" -lt 2 ]; then
        echo "Input the cluster region and number e.g: kctx euw 06"
    fi
  
  env=${3:-np}

  echo "env: $env"
  if [ -z $1 ]; then
    kubectl config get-contexts
  else
    if ! kubectl config use-context as-$env-$1-web-$2-aks; then
        echo "Try logging in with: klogin $1 $2 $env"
    fi
  fi
}

# Description: See which clusters are available
# Usage: kinfo
kinfo() {
    nonprod_sub="b97b4ae3-ccc5-46d9-9739-831517bfd51c"
    prod_sub="2896e29c-5128-42e3-a50b-e13e7d47a59e"
    
    if ! which jq > /dev/null; then
        echo "Install jq for json parsing with: brew install jq"
        return 1
    fi

    echo "CLUSTERS:"
    echo "Region Number Subscription"
    az account set --subscription $nonprod_sub
    echo "Nonprod:"
    az aks list | jq '.[].name' | awk -F '-' '{print $3 " " $5 " " $2}'
    echo

    echo "Prod:"
    az account set --subscription $prod_sub
    az aks list | jq '.[].name' | awk -F '-' '{print $3 " " $5 " " $2}'

    # cat aks.json| jq '.[].name' | awk -F '-' '{print $3 " " $5 " " $2}'

    echo -e "\nE.g Login to cluster euw 06 np with: klogin euw 06 np"

    echo """REGIONS:
euw = West Europe
eun = North Europe
usnc = North Central US
ase = Southeast Asia
"""
}