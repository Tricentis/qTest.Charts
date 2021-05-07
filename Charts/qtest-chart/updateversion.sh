str1="$(grep -w 'version:' Chart.yaml)"
minorVS="${str1##*.}"
minorVS=$((minorVS+1))
str2="${str1%.*}.$minorVS"
sed "s/version:.*/$str2/g" Chart.yaml

str3="$(grep -w 'appVersion:' Chart.yaml)"
minorVS="${str3##*.}"
minorVS="${minorVS%?}"
minorVS=$((minorVS+1))
str4="${str3%.*}.$minorVS\""
sed "s/appVersion:.*/$str4/g" Chart.yaml