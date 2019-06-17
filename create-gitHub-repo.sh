#!/bin/bash

usage()
{
    echo "usage: sysinfo_page [[[-f file ] [-i]] | [-h]]"
}

generate_post_data()
{
  cat <<EOF
{
  "name": "$repo",
  "description": "This is your first repository",
  "homepage": "https://github.com",
  "private": "$private",
  "has_issues": true,
  "has_projects": true,
  "has_wiki": true,
  "auto_init": "$autoinit"
}
EOF
}

initialize_local_git_repo()
{

  # create a directory and go there
  cd "$REPOPATH"
  git clone https://"$USER:$PASS"@github.com/"$USER"/"$repo"

}

run_main()
{

  test -z $repo && echo "Repo name required." 1>&2 && exit 1

  # Read the configuration file
  IFS="="
  while read var value
  do
      eval "$var"="$value"
  done < "/home/spavko/Desktop/CVs/Interview_Prep/create-gitHub-repo/config.txt"

  # create a repo online
  curl -u $USER:$TOKEN https://api.github.com/user/repos -d "$(generate_post_data)"

  initialize_local_git_repo
}

while [ "$1" != "" ]; do
    case $1 in
        -p | --private )        private=1
                                ;;
        -a | --autoinit )       autoinit=1
                                ;;
        -h | --help )           usage
                                ;;
        * )                     repo=$1
    esac
    shift
done

run_main

cd "$REPOPATH$repo"
