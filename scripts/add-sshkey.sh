set -o errexit    # always exit on error
set -o pipefail   # don't ignore exit codes when piping output
set -o posix      # more strict failures in subshells
set -x            # debugging

env_dir=${1:-}
ssh_key_file=${env_dir}/CUSTOMIZE_GIT_SSH_KEY
GIT_SSH_KEY=$(cat ${ssh_key_file})

if [ "$GIT_SSH_KEY" != "" ]; then
      echo "Detected SSH key for git. Adding SSH config" >&1
      echo "" >&1

      # Ensure we have an ssh folder
      if [ ! -d ~/.ssh ]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
      fi

      # Load the private key into a file.
      cat ${ssh_key_file} | base64 --decode > ~/.ssh/deploy_key

      # Change the permissions on the file to
      # be read-only for this user.
      chmod 400 ~/.ssh/deploy_key

      # Setup the ssh config file.
      echo <<EOF
          Host github.com
            IdentityFile ~/.ssh/deploy_key
            IdentitiesOnly yes
            UserKnownHostsFile=/dev/null
            StrictHostKeyChecking no
          EOF > ~/.ssh/config
      cat ~/.ssh/config
fi
