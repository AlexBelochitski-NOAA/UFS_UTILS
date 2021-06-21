#!/bin/bash

#----------------------------------------------------------------------
# Retrieve gfs v15 retrospective parallel data from hpss.
#----------------------------------------------------------------------

set -x

#MEMBER=$1
bundle=$1

cd $EXTRACT_DIR

if [ "$bundle" = "gfs" ]; then

  if [ ${yy}${mm}${dd}${hh} -lt 2017052418 ]; then
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2
  elif [ ${yy}${mm}${dd}${hh} -lt 2017080200 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/fv3q2fy19retro2/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2017112500 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro2/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2018032812 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro1/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2019061106 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/prfv3rt1/${yy}${mm}${dd}${hh}
  else
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2
  fi

  file=gfs_nemsioa.tar

  touch ./list.hires3
  htar -tvf  $directory/$file > ./list.hires1
  grep sfcanl ./list.hires1 > ./list.hires2
  grep atmanl ./list.hires1 >> ./list.hires2
  while read -r line
  do
    echo ${line##*' '} >> ./list.hires3
  done < "./list.hires2"

  htar -xvf $directory/$file -L ./list.hires3
  rc=$?
  [ $rc != 0 ] && exit $rc
  
  rm -f ./list.hires?

#else
elif [ $bundle = 'gdas' ]; then


  date10_m6=`$NDATE -6 $yy$mm$dd$hh`

  echo $date10_m6
  yy_m6=$(echo $date10_m6 | cut -c1-4)
  mm_m6=$(echo $date10_m6 | cut -c5-6)
  dd_m6=$(echo $date10_m6 | cut -c7-8)
  hh_m6=$(echo $date10_m6 | cut -c9-10)

  if [ $date10_m6 -lt  2017052418 ]; then
   set +x
   echo NO DATA FOR $date10_m6
   exit 2
  elif [ $date10_m6 -le 2017080200 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/fv3q2fy19retro2/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ $date10_m6 -lt 2017112500 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro2/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ $date10_m6 -lt 2018053118 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro1/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ $date10_m6 -lt 2019061106 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/prfv3rt1/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  else
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2

  fi

#----------------------------------------------------------------------
# Pull restart files.
#----------------------------------------------------------------------

  file=gdas_restartb.tar

  rm -f ./list.hires*
  touch ./list.hires3
  htar -tvf  $directory/$file > ./list.hires1
  grep ${yy}${mm}${dd}.${hh} ./list.hires1 > ./list.hires2
  while read -r line
  do 
    echo ${line##*' '} >> ./list.hires3
  done < "./list.hires2"

  htar -xvf $directory/$file -L ./list.hires3
  rc=$?
  [ $rc != 0 ] && exit $rc

#----------------------------------------------------------------------
# Pull abias and radstat files.
#----------------------------------------------------------------------

  rm -f ./list.hires*


  if [ ${yy}${mm}${dd}${hh} -lt 2017052418 ]; then
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2
  elif [ ${yy}${mm}${dd}${hh} -lt 2017080200 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/fv3q2fy19retro2/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2017112500 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro2/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2018053118 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro1/${yy}${mm}${dd}${hh}
  elif [ ${yy}${mm}${dd}${hh} -lt 2019061106 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/prfv3rt1/${yy}${mm}${dd}${hh}
  else
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2
  fi


  file=gdas_restarta.tar

  touch ./list.hires3
  htar -tvf  $directory/$file > ./list.hires1
  grep abias ./list.hires1 > ./list.hires2
  grep radstat ./list.hires1 >> ./list.hires2
  while read -r line
  do
    echo ${line##*' '} >> ./list.hires3
  done < "./list.hires2"

  htar -xvf $directory/$file -L ./list.hires3
  rc=$?
  [ $rc != 0 ] && exit $rc

#----------------------------------------------------------------------
# Get the enkf tiled restart files for all members.  They are not
# stored for the current cycle, so use the 6-hr old tarball.
#----------------------------------------------------------------------

else

  date10_m6=`$NDATE -6 $yy$mm$dd$hh`

  echo $date10_m6
  yy_m6=$(echo $date10_m6 | cut -c1-4)
  mm_m6=$(echo $date10_m6 | cut -c5-6)
  dd_m6=$(echo $date10_m6 | cut -c7-8)
  hh_m6=$(echo $date10_m6 | cut -c9-10)


  if [ ${yy}${mm}${dd}${hh} -lt 2017052418 ]; then
    set +x
    echo NO DATA FOR ${yy_m6}${mm_m6}${dd_m6}${hh_m6}
    exit 2
  elif [ ${yy}${mm}${dd}${hh} -lt 2017080200 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/fv3q2fy19retro2/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ ${yy}${mm}${dd}${hh} -lt 2017112500 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro2/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ ${yy}${mm}${dd}${hh} -lt 2018053118 ]; then
    directory=/NCEPDEV/emc-global/5year/Fanglin.Yang/WCOSS_DELL_P3/Q2FY19/fv3q2fy19retro1/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  elif [ ${yy}${mm}${dd}${hh} -lt 2019061106 ]; then
    directory=/NCEPDEV/emc-global/5year/emc.glopara/WCOSS_C/Q2FY19/prfv3rt1/${yy_m6}${mm_m6}${dd_m6}${hh_m6}
  else
    set +x
    echo NO DATA FOR ${yy}${mm}${dd}${hh}
    exit 2
  fi

  file=enkf.gdas_${bundle}.tar
  filer=enkf.gdas_restartb_${bundle}.tar

#    rm -f ./list*.${bundle}
#    htar -tvf  $directory/$file > ./list1.${bundle}
#    grep ${yy}${mm}${dd}.${hh} ./list1.${bundle} > ./list2.${bundle}
#    while read -r line
#    do 
#      echo ${line##*' '} >> ./list3.${bundle}
#    done < "./list2.${bundle}"
#    htar -xvf $directory/$file  -L ./list3.${bundle}
#    rc=$?
#    [ $rc != 0 ] && exit $rc
#    rm -f ./list*.${bundle}

  htar -xvf $directory/$file  ./enkf.gdas.${yy_m6}${mm_m6}${dd_m6}/${hh_m6}/mem001/gdas.t${hh_m6}z.atmf006.nemsio
  htar -xvf $directory/$filer  ./enkf.gdas.${yy_m6}${mm_m6}${dd_m6}/${hh_m6}/mem001/
  mv ./enkf.gdas.${yy_m6}${mm_m6}${dd_m6}/ ./enkfgdas.${yy_m6}${mm_m6}${dd_m6}/

fi # is this gdas or gfs CDUMP?

set +x
echo DATA PULL FOR v15 retro DONE

exit 0
