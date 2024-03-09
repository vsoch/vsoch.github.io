BASEURL=https://${CIRCLE_BUILD_NUM}-41881188-gh.circle-artifacts.com/0/vsoch.github.io
sed -i "63 s,.*,destination: ./_site,g" "_config.yml"
sed -i "6 s,.*,baseurl: $BASEURL,g" "_config.yml"
