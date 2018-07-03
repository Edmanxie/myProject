#!/bin/bash 
#
# Copyright (c) 2017, The CTF Foundation. All rights reserved.
# Functions :  User for msm8976 platform
# Author    :  Welling Yao
# Version   :  0.2
# History   ： V0.1  - Initial version 
#              V0.2  - Add BUILD_TOP/src folder for C8 new baseline
#s

BUILD_TOP=$PWD
OUT_BIN_PATH=$BUILD_TOP/out-bin
OUT_ELF_PATH=$BUILD_TOP/out-bin/elf

function copy_factory_delta_image()
{
  echo "=======================OUT FACTORY XML============================================"
  cd $BUILD_TOP/src
  cp common/build/misc.img     $OUT_BIN_PATH/
  cp common/build/zero_fs1.bin $OUT_BIN_PATH/
  cp common/build/zero_fs2.bin $OUT_BIN_PATH/
  cp splash/splash.img         $OUT_BIN_PATH/
    
  echo "\n ****** final.img for Nicaragua ****** \n"
  cp common/build/final.img    $OUT_BIN_PATH/ 
    
  cp common/build/bin/asic/sparse_images/rawprogram_unsparse.xml $OUT_BIN_PATH/rawprogram_unsparse_factory.xml
  #cp $BUILD_TOP/common/build/fs_image.tar.gz.mbn.img $OUT_BIN_PATH/
  echo "=======================OUT FACTORY XML END========================================"
  cd -
}

function generate_user_xml()
{
  echo "========= Generate user xml =================="
  cd $OUT_BIN_PATH
  cp rawprogram_unsparse_factory.xml rawprogram_unsparse.xml

  echo "Remove the factory delate bin file name on rawprogram_unsparse.xml "
  sed -i 's/zero_fs1.bin//g'  rawprogram_unsparse.xml
  sed -i 's/zero_fs2.bin//g'  rawprogram_unsparse.xml
  sed -i 's/persist_1.img//g' rawprogram_unsparse.xml
  sed -i 's/misc.img//g'      rawprogram_unsparse.xml
  sed -i 's/final.img//g'      rawprogram_unsparse.xml
  #sed -i 's/fs_image.tar.gz.mbn.img//g' rawprogram_unsparse.xml
  
  build_type=`echo $TARGET_BUILD_VARIANT`
  echo $build_type
  if [ "$build_type" = "user" ]; then
	echo "build_type is user"
	rm -rf $OUT_BIN_PATH/rawprogram_unsparse_factory.xml
  else 
	echo "build_type is userdebug"
  fi
  
  cd -
}

function copy_non_hlos_android_image()
{
  echo "------------------  copy file to out-bin ------------------"
  cd $BUILD_TOP/src
  cp  contents.xml                                         $OUT_BIN_PATH
      
  cp  modem/NON-HLOS.bin                                   $OUT_BIN_PATH
  cp  common/build/bin/asic/sparse_images/cache_*.img      $OUT_BIN_PATH
  cp  common/build/bin/asic/sparse_images/system_*.img     $OUT_BIN_PATH
  cp  common/build/bin/asic/sparse_images/userdata_*.img   $OUT_BIN_PATH
  cp  common/build/bin/asic/sparse_images/persist_1.img    $OUT_BIN_PATH

  #cp  common/build/bin/asic/pil_split_bins/*               $OUT_BIN_PATH
  cp  common/build/gpt_main0.bin                           $OUT_BIN_PATH
  cp  common/build/gpt_backup0.bin                         $OUT_BIN_PATH
  cp  common/build/patch0.xml                              $OUT_BIN_PATH
  cp  common/sectools/resources/build/fileversion2/sec.dat $OUT_BIN_PATH
  cp  common/build/gpt_both0.bin                           $OUT_BIN_PATH
      
  cp  boot_images/build/ms/bin/EAADANAZ/unsigned/prog_emmc_firehose_8976_ddr.mbn $OUT_BIN_PATH
  cp  boot_images/build/ms/bin/EAASANAZ/sbl1.mbn                 $OUT_BIN_PATH
  cp  rpm_proc/build/ms/bin/8976/rpm.mbn                         $OUT_BIN_PATH
  cp  adsp_proc/build/dynamic_signed/8976/adspso.bin             $OUT_BIN_PATH
  cp  trustzone_images/build/ms/bin/MAYAANAA/tz.mbn              $OUT_BIN_PATH
  cp  trustzone_images/build/ms/bin/MAYAANAA/devcfg.mbn          $OUT_BIN_PATH
  cp  trustzone_images/build/ms/bin/MAYAANAA/cmnlib.mbn          $OUT_BIN_PATH
  cp  trustzone_images/build/ms/bin/MAYAANAA/cmnlib64.mbn        $OUT_BIN_PATH
  cp  trustzone_images/build/ms/bin/MAYAANAA/keymaster.mbn       $OUT_BIN_PATH

  cp  LINUX/android/out/target/product/msm8952_64/recovery.img        $OUT_BIN_PATH
  cp  LINUX/android/out/target/product/msm8952_64/boot.img            $OUT_BIN_PATH
  cp  LINUX/android/out/target/product/msm8952_64/emmc_appsboot.mbn   $OUT_BIN_PATH
  cp  LINUX/android/out/target/product/msm8952_64/mdtp.img            $OUT_BIN_PATH
  #cp  splash/splash.img                                              $OUT_BIN_PATH	

  cd -
}

function copy_cdt_image()
{
  cd  $BUILD_TOP
  cp  img/cdt_images/cdt_030B010000/platform_ddr.bin    $OUT_BIN_PATH
  cp  img/cdt_images/cdt_030B010000/patch2.xml          $OUT_BIN_PATH
  cp  img/cdt_images/cdt_030B010000/gpt_backup2.bin     $OUT_BIN_PATH
  cp  img/cdt_images/cdt_030B010000/gpt_main2.bin       $OUT_BIN_PATH
  cp  img/cdt_images/cdt_030B010000/rawprogram2.xml     $OUT_BIN_PATH
  cd -
}

function copy_elf_files()
{
  cd $BUILD_TOP/src
  #cp adsp_proc/build/ms/*.elf                                     $OUT_ELF_PATH/
  #cp modem_proc/build/ms/*.elf                                    $OUT_ELF_PATH/
  #cp trustzone_images/core/bsp/tzbsp/build/MAZAANAA/*.elf         $OUT_ELF_PATH/
  #cp rpm_proc/core/bsp/rpm/build/8909/pm8909/*.elf                $OUT_ELF_PATH/
  #cp boot_images/core/bsp/bootloaders/sbl1/build/DAASANAZ/*.elf   $OUT_ELF_PATH/
  #cp wcnss_proc/build/ms/*.elf                                    $OUT_ELF_PATH/
  cp LINUX/android/out/target/product/msm8952_64/obj/KERNEL_OBJ/vmlinux $OUT_ELF_PATH/
  cd - 
}

function parser_partition_generate_image()
{
  echo "------------- delete out-bin ------------------------"
  rm -rf $OUT_BIN_PATH
  mkdir  $OUT_BIN_PATH
  mkdir  $OUT_ELF_PATH
  
  echo "--------------  delete commom/build   ------------------"
  rm -rf $BUILD_TOP/src/common/build/bin/
  
  # Generate image
  # cp -f $BUILD_TOP/src/common/config/partition_factory.xml $BUILD_TOP/src/common/config/partition.xml
  cd $BUILD_TOP/src/common/build/
  /usr/bin/python ./build.py
  cd -
}

function main()
{
  # Paser partition and generate image
  parser_partition_generate_image

  # Copy factory special bin
  copy_factory_delta_image $1

  # Copy out NON-HLOS and all android image
  copy_non_hlos_android_image

  # Copy cdt image
  copy_cdt_image

  # Copy NON-HLOS and Linux elf files
  copy_elf_files

  # Generate user xml
  generate_user_xml
  
  echo "Done! Binaries are generated to: ./out-bin/"
}

main $@
