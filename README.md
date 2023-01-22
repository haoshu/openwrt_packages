# how to build openwrt custom package
```
cd openwrt/

echo 'src-git haoshu https://github.com/haoshu/openwrt_packages.git' >> feeds.conf.default
./scripts/feeds update
cat feeds/haoshu.index | grep duo_unix

./scripts/feeds install duo_unix-login
./scripts/feeds install duo_unix-pam

make menuconfig

make prepare -j$(nproc)
make package/duo_unix/compile -j$(nproc)

ls bin/packages/*/haoshu/duo_unix-* 
```

# how to update Makefile of openwrt custom package
```
cd openwrt/

sed --in-place -e 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=skip/' feeds/haoshu/libs/duo_unix/Makefile

make package/duo_unix/download V=s
make package/duo_unix/check FIXUP=1 V=s
