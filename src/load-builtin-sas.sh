#!/bin/sh

LSI_SAS_6Gb_kmod="/lib/modules/mpt2sas.ko"
LSI_SAS_12Gb_kmod="/lib/modules/mpt3sas.ko"
SAS_drivers_loaded=0

echo "Loading SAS controller(s) driver(s)"

# Legacy LSI 6Gb driver (kernel v3 mostly, in newer ones mpt3sas merged mpt2sas functionality)
if [ -e "${LSI_SAS_6Gb_kmod}" ]; then
  echo "Loading LSI SAS 6Gb driver from ${LSI_SAS_6Gb_kmod}"
  insmod "${LSI_SAS_6Gb_kmod}"
  SAS_drivers_loaded=1
else
  echo "${LSI_SAS_6Gb_kmod} not found - skipping"
fi

# In newer kernels there's a newer 12Gb driver as well
if [ -e "${LSI_SAS_12Gb_kmod}" ]; then
  echo "Loading LSI SAS 12Gb driver from ${LSI_SAS_12Gb_kmod}"
  insmod "${LSI_SAS_12Gb_kmod}"
  SAS_drivers_loaded=1
else
  echo "${LSI_SAS_12Gb_kmod} not found - skipping"
fi

if [ $SAS_drivers_loaded -eq 1 ]; then
  sleep 2 # we need to wait for disks to be detected so other processes don't randomly explode
else
  echo "No SAS drivers were loaded - this extension did nothing. This is a problem as it looks like the extension was loaded ona platform which cannot support it!"
  exit 1
fi
