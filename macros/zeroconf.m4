dnl Check for optional Zeroconf support

AC_DEFUN([AC_NETATALK_ZEROCONF], [
	ZEROCONF_LIBS=""
	ZEROCONF_CFLAGS=""
	found_zeroconf=no
	zeroconf_dir=""

	AC_ARG_ENABLE(zeroconf,
		[  --enable-zeroconf[[=DIR]]   enable Zeroconf support [[auto]]],
		[zeroconf=$enableval],
		[zeroconf=try]
	)

    dnl make sure atalk_libname is defined beforehand
    [[ -n "$atalk_libname" ]] || AC_MSG_ERROR([internal error, atalk_libname undefined])

	if test "x$zeroconf" != "xno"; then
		savedcppflags="$CPPFLAGS"
		savedldflags="$LDFLAGS"

		if test "x$zeroconf" = "xyes" -o "x$zeroconf" = "xtry"; then
			zeroconf_dir="/usr"
		else
			zeroconf_dir="$zeroconf"
		fi

        # mDNS support using mDNSResponder
        if test x"$found_zeroconf" != x"yes" ; then
            AC_CHECK_HEADER(
                dns_sd.h, [
                AC_DEFINE(USE_ZEROCONF, 1, [Use DNS-SD registration])
            ])

            AC_DEFINE(HAVE_MDNS, 1, [Use mDNSRespnder/DNS-SD registration])
            found_zeroconf=yes
		fi
	fi

	netatalk_cv_zeroconf=no
	AC_MSG_CHECKING([whether to enable Zeroconf support])
	if test "x$found_zeroconf" = "xyes"; then
		AC_MSG_RESULT([yes])
		AC_DEFINE(USE_ZEROCONF, 1, [Define to enable Zeroconf support])
		netatalk_cv_zeroconf=yes
	else
		AC_MSG_RESULT([no])
		if test "x$zeroconf" != "xno" -a "x$zeroconf" != "xtry"; then
			AC_MSG_ERROR([Zeroconf installation not found])
		fi
	fi

	LIB_REMOVE_USR_LIB(ZEROCONF_LIBS)
	CFLAGS_REMOVE_USR_INCLUDE(ZEROCONF_CFLAGS)
	AC_SUBST(ZEROCONF_LIBS)
	AC_SUBST(ZEROCONF_CFLAGS)
])
