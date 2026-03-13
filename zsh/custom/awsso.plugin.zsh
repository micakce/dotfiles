# TF k8s provider uses this variable
# It applies to Kubernetes and Helm TF providers > 2.0
# issue <https://github.com/hashicorp/terraform-provider-kubernetes/issues/1175>

export KUBE_CONFIG_PATH=$KUBECONFIG

function profile_info() {
  if [ -z "$AWS_PROFILE" ]; then
    echo "No profile active"
  else
    echo "AWS profile: $AWS_PROFILE role: $AWS_ROLE"
  fi
}

function leapp_profile_init() {
  if [[ -z $(_check_leapp_installed) ]]
  then
    leapp integration sync
    sessions=$(_get-leapp-sessions-json)
    for row in $(echo "${sessions}" | jq -r '.[] | @base64'); do
        _jq() {
         echo ${row} | base64 --decode | jq -r ${1}
        }
       sessionName=$(_jq '.sessionName')
       sessionRole=$(_jq '.role')
       sessionId=$(_jq '.id')
       role=$(_translate_aws_role_to_custom_role "$sessionRole")
       profileName="$sessionName-$role"
       if [[ $(_jq '.profileId') == "default" ]]
       then
           if ! leapp profile list --filter="Profile Name=$profileName" --no-header | grep -q .; then
               echo "creating profile '$profileName' for session '$sessionName' with role '$sessionRole'"
               leapp profile create --profileName "$profileName"
           else
               echo "profile '$profileName' already exists, skipping creation"
           fi
           profileId=$(leapp profile list --columns="ID" --no-header --filter="Profile Name=$profileName" | head -n 1 | xargs)
           leapp session change-profile --sessionId "$sessionId" --profileId "$profileId"
       else
           echo "non default profile '$profileName' for session '$sessionName' with role '$sessionRole' already created and assigned";
       fi
    done
  else
    echo "Leapp does not seem to be installed"
  fi
}

function aws_login() {
  if [[ -z $(_check_leapp_installed) ]]
  then
    if [ -n "$1" ]
    then
      IFS='@' read -r parameterRole sessionName <<<"$1"
      role=$(_translate_custom_role_to_aws_role "$parameterRole")
      sessionId=$(_get-leapp_session-id $role $sessionName)
      if [[ -n $sessionId ]]
      then
        session=$(_get-leapp-sessions-by-id $sessionId)
      fi
    else
      session=$(_get-leapp-sessions | fzf)
      sessionId=$session
    fi
    if [[ -z $session || -z $sessionId ]]
    then
      echo "No matching profile found, keeping current"
    else
      eval _leapp-session-start $session
      aws sts get-caller-identity > /dev/null 2>&1 || {
        echo "SSO session expired/invalid for profile '$AWS_PROFILE'. Running aws sso login..."
        aws sso login --profile "$AWS_PROFILE" || return 1
      }
    fi
  else
    echo "Leapp does not seem to be installed"
  fi
}

_get-leapp-sessions(){
  leapp session list --no-truncate --columns="Session Name,Role,Named Profile" --no-header
}

_get-leapp-sessions-json(){
  leapp session list -x --output=json | jq -c
}

_get-leapp-sessions-by-id(){
  leapp session list --no-truncate --columns="Session Name,Role,Named Profile" --no-header --filter="ID=$1"
}

_get-leapp_session-id(){
  _get-leapp-sessions-json | jq -r 'map(select(.role == "'$1'" and .sessionName =="'$2'").id) | .[]'
}

_leapp-session-start(){
  if [ -n "$1" ]
    then
    if [ ! "$(leapp session current --profile $3 2> /dev/null)" ]
    then
      leapp session start $1 --sessionRole $2 --noInteractive;
    fi
    export AWS_DEFAULT_PROFILE=$3;
    export AWS_PROFILE=${AWS_DEFAULT_PROFILE}
    export LEAPP_SESSION=$1
    export AWS_ROLE=$2
    customRole=$(_translate_aws_role_to_custom_role "$2")
    export CUSTOM_ROLE=$customRole
  fi
}

_translate_custom_role_to_aws_role(){
  if [[ $1 == "admin" ]]
  then
    echo "restricted-admin"
  elif [[ $1 == "superadmin" ]]
  then
    echo "admin"
  else
    echo "$1"
  fi
}

_translate_aws_role_to_custom_role(){
  if [[ $1 == "restricted-admin" ]]
  then
    echo "admin"
  elif [[ $1 == "admin" ]]
  then
    echo "superadmin"
  else
    echo "$1"
  fi
}

_check_leapp_installed() {
  if [ ! "$(leapp version 2> /dev/null)" ]
  then
    echo "not installed"
  fi
 }

### Aliases
alias aws-region-eu-west-1="export AWS_DEFAULT_REGION=eu-west-1; export AWS_REGION=eu-west-1;"
alias aws-region-eu-central-1="export AWS_DEFAULT_REGION=eu-central-1; export AWS_REGION=eu-central-1;"
alias aws-region-eu-central-2="export AWS_DEFAULT_REGION=eu-central-2; export AWS_REGION=eu-central-2;"
alias aws-region-ca-central-1="export AWS_DEFAULT_REGION=ca-central-1; export AWS_REGION=ca-central-1;"
alias aws-region-us-east-1="export AWS_DEFAULT_REGION=us-east-1; export AWS_REGION=us-east-1;"
alias aws-region-us-west-1="export AWS_DEFAULT_REGION=us-west-1; export AWS_REGION=us-west-1;"
alias aws-region-ap-southeast-1="export AWS_DEFAULT_REGION=ap-southeast-1; export AWS_REGION=ap-southeast-1;"
alias aws-region-sa-east-1="export AWS_DEFAULT_REGION=sa-east-1; export AWS_REGION=sa-east-1;"
alias aws-region-ap-northeast-1="export AWS_DEFAULT_REGION=ap-northeast-1; export AWS_REGION=ap-northeast-1;"
alias aws-region-ap-southeast-2="export AWS_DEFAULT_REGION=ap-southeast-2; export AWS_REGION=ap-southeast-2;"

