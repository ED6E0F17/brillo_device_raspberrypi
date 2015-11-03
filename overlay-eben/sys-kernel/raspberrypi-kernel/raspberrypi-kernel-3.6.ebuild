# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4

CROS_WORKON_REPO="git://github.com/raspberrypi"
CROS_WORKON_PROJECT="linux"
CROS_WORKON_BLACKLIST="1"
CROS_WORKON_COMMIT="05960cea116786864fd1f1bceb3a250b053adccb"

# This must be inherited *after* EGIT/CROS_WORKON variables defined
inherit git-2 cros-kernel2 cros-workon

DESCRIPTION="Chrome OS Kernel-raspberrypi"
KEYWORDS="arm"

DEPEND="!sys-kernel/chromeos-kernel-next
	!sys-kernel/chromeos-kernel
"
RDEPEND="${DEPEND}"

src_install() {
	cros-kernel2_src_install

	"${FILESDIR}/mkimage/imagetool.py" \
		"$(cros-workon_get_build_dir)/arch/${ARCH}/boot/Image" \
		"${T}/kernel.img"

	insinto /boot
	doins "${FILESDIR}"/{cmdline,config}.txt
	doins "${T}/kernel.img"
}
