curl -v -X POST -H "X-Communication-Id: $X_COMMUNICATION_ID_ITG" -H "X-Auth-Token: $X_AUTH_TOKEN_ITG" -H "Content-Type: multipart/form-data" -F "file=@build/install/crs8032_2en_us.zip" 'https://api-itg.support.hpe.com/document-loader/v1/pushcontent/';
curl -v -X POST -H "X-Communication-Id: $X_COMMUNICATION_ID_ITG" -H "X-Auth-Token: $X_AUTH_TOKEN_ITG" -H "Content-Type: multipart/form-data" -F "file=@build/admin/crs8033_2en_us.zip" 'https://api-itg.support.hpe.com/document-loader/v1/pushcontent/'
