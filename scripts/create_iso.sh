#!/bin/sh
build_dir="/build"
mkdir 
if [ ! -d "${build_dir}/isolinux" ]; then
	echo "##### Start Downloading #####"
  cd /tmp
	wget -nv -r --accept-regex=$MIRROR_URL/isolinux/* $MIRROR_URL/isolinux/
	wget -nv -r --accept-regex=$MIRROR_URL/images/* $MIRROR_URL/images/
	wget -nv -r --accept-regex=$MIRROR_URL/LiveOS/* $MIRROR_URL/LiveOS/

	# remove index files
	find . -type f -name index.html\* -exec rm {} \;

	mirror_path="/tmp/`echo $MIRROR_URL | sed 's/https\?:\/\///'`"

	mv ${mirror_path}/isolinux ${build_dir}/
	mv ${mirror_path}/images ${build_dir}/isolinux/
	mv ${mirror_path}/LiveOS ${build_dir}/isolinux/
	rm -r --interactive=never ${mirror_path}
  cd ${build_dir}
fi

# include kickstart config
mkdir -p ${build_dir}/isolinux/config
cp anaconda-ks.cfg ${build_dir}/isolinux/config/ks.cfg

cp /scripts/isolinux.cfg ${build_dir}/isolinux/isolinux.cfg

chmod 664 ${build_dir}/isolinux/isolinux.bin

mkisofs -o custom.iso -b isolinux.bin -c boot.cat -no-emul-boot \
  -V 'CentOS 7 x86_64' \
  -boot-load-size 4 -boot-info-table -R -J -v -T isolinux/
