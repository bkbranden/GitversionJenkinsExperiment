set +x
# Run only if there are commits after the last tag.
if [[ ! $(git tag --contains HEAD) ]]; then
  # Get the last commit on the local Repo.
  COMMIT=$(git rev-parse HEAD)

  # Get version and update frontend and backend files.
  version=$(docker run --rm -v "$(pwd):/repo" gittools/gitversion:5.3.5-linux-alpine.3.10-x64-netcoreapp3.1 /repo \
                                                                                  /url "${GIT_REPOURL}" \
                                                                                  /b "${BRANCH_NAME}" \
                                                                                  /u "${GITHUB_USER}" \
                                                                                  /p "${GITHUB_PW}" \
                                                                                  /c "${COMMIT}" | jq -r .SemVer)
  echo "The current version is \"${version}\""
  tmp=$(mktemp)
  jq ".version = \"${version}\"" ui/src/version.json > "$tmp"
  cp "${tmp}" ui/src/version.json
  cp "${tmp}" src/config/version.json

  # Config Git.
  git config --global user.email "bk2dh@virginia.edu"
  git config --global user.name "bkbranden"
  git config --global push.default current

  # Commit and push everything.
  git add ui/src/version.json
  git add src/config/version.json
  git tag "v${version}"
  git push origin ${BRANCH_NAME} "v${version}"
else
  echo "HEAD already tagged."
fi