# function fec2() {
#     aws ec2 describe-instances \
#       --no-cli-pager \
#       --filters "Name=instance-state-name,Values=running" \
#       --query "Reservations[*].Instances[*].{InstanceId:InstanceId,Name:Tags[?Key=='Name'] |[0].Value,InstanceType:InstanceType,PublicIpAddress:PublicIpAddress}" \
#       --output table --region eu-west-1 | \
#         fzf \
#           --bind "enter:execute(EC2ID={2}; echo -n \${EC2ID%?} | ${FZF_COPY_CMD}; echo -n \"Copied {5} id to clipboard\" )+abort" \
#           --header-lines=5
# }


function fec2() {
  # Default region
  local region="eu-west-1"

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --region)
        region="$2"
        shift 2
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
  done

  aws ec2 describe-instances \
    --no-cli-pager \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].{InstanceId:InstanceId,Name:Tags[?Key=='Name'] |[0].Value,InstanceType:InstanceType,PublicIpAddress:PublicIpAddress}" \
    --output text \
    --region "$region" | \
      awk 'BEGIN { printf "%-20s %-12s %-50s %-15s\n", "InstanceID", "InstanceType", "Name", "PublicIPAddress" }
          { name = length($3) > 47 ? substr($3, 1, 47) "..." : $3;
            printf "%-20s %-12s %-50s %-15s\n", $1, $2, name, $4  }' | \
      fzf \
        --bind "enter:execute(echo -n {1} | ${FZF_COPY_CMD}; echo -n \"Copied {1} id to clipboard\" )+abort" \
        --header-lines=1
}
