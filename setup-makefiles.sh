#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=ginkgo
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function vendor_imports() {
    cat <<EOF >>"$1"
       "device/xiaomi/ginkgo",
       "hardware/qcom-caf/sm8150",
       "hardware/qcom-caf/wlan",
       "vendor/qcom/opensource/commonsys/display",
       "vendor/qcom/opensource/commonsys-intf/display",
       "vendor/qcom/opensource/dataservices",
       "vendor/qcom/opensource/data-ipa-cfg-mgr-legacy-um",
       "vendor/qcom/opensource/display",
EOF
}

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
            com.qualcomm.qti.dpm.api@1.0 | \
            com.qualcomm.qti.imscmservice@2.0 | \
            com.qualcomm.qti.imscmservice@2.1 | \
            com.qualcomm.qti.imscmservice@2.2 | \
            com.qualcomm.qti.uceservice@2.0 | \
            com.qualcomm.qti.uceservice@2.1 | \
            vendor.qti.hardware.data.* | \
            vendor.qti.latency* | \
            vendor.qti.hardware.fm@1.0 | \
            vendor.qti.ims.callinfo@1.0 | \
            vendor.qti.ims.rcsconfig@1.0 | \
            vendor.qti.ims.rcsconfig@1.1 | \
            vendor.qti.imsrtpservice@3.0 | \
            vendor.dolby.hardware.dms@2.0)
            echo "${1}_vendor"
            ;;
            libgrallocutils | \
            libwpa_client)
            ;;
            libprotobuf-cpp-full)
            echo "libprotobuf-cpp-full-vendorcompat"
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt" true

# Finish
write_footers
