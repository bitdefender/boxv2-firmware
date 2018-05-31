Index: mtd-utils-1.5.1/jffs2reader.c
===================================================================
--- mtd-utils-1.5.1.orig/jffs2reader.c
+++ mtd-utils-1.5.1/jffs2reader.c
@@ -62,6 +62,11 @@ BUGS:
 - Doesn't check CRC checksums.
  */
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #define PROGRAM_NAME "jffs2reader"
 
 #include <stdint.h>
Index: mtd-utils-1.5.1/lib/libmtd.c
===================================================================
--- mtd-utils-1.5.1.orig/lib/libmtd.c
+++ mtd-utils-1.5.1/lib/libmtd.c
@@ -21,6 +21,11 @@
  * MTD library.
  */
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include <limits.h>
 #include <stdlib.h>
 #include <stdio.h>
Index: mtd-utils-1.5.1/lib/libmtd_legacy.c
===================================================================
--- mtd-utils-1.5.1.orig/lib/libmtd_legacy.c
+++ mtd-utils-1.5.1/lib/libmtd_legacy.c
@@ -23,6 +23,11 @@
  * not possible to get sub-page size.
  */
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include <limits.h>
 #include <fcntl.h>
 #include <unistd.h>
Index: mtd-utils-1.5.1/mkfs.jffs2.c
===================================================================
--- mtd-utils-1.5.1.orig/mkfs.jffs2.c
+++ mtd-utils-1.5.1/mkfs.jffs2.c
@@ -49,6 +49,11 @@
 
 #define PROGRAM_NAME "mkfs.jffs2"
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include <sys/types.h>
 #include <stdio.h>
 #include <sys/stat.h>
Index: mtd-utils-1.5.1/mkfs.ubifs/devtable.c
===================================================================
--- mtd-utils-1.5.1.orig/mkfs.ubifs/devtable.c
+++ mtd-utils-1.5.1/mkfs.ubifs/devtable.c
@@ -44,6 +44,11 @@
  * for more information about what the device table is.
  */
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include "mkfs.ubifs.h"
 #include "hashtable/hashtable.h"
 #include "hashtable/hashtable_itr.h"
Index: mtd-utils-1.5.1/mkfs.ubifs/mkfs.ubifs.c
===================================================================
--- mtd-utils-1.5.1.orig/mkfs.ubifs/mkfs.ubifs.c
+++ mtd-utils-1.5.1/mkfs.ubifs/mkfs.ubifs.c
@@ -22,6 +22,11 @@
 
 #define _XOPEN_SOURCE 500 /* For realpath() */
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include "mkfs.ubifs.h"
 #include <crc32.h>
 #include "common.h"
Index: mtd-utils-1.5.1/tests/ubi-tests/integ.c
===================================================================
--- mtd-utils-1.5.1.orig/tests/ubi-tests/integ.c
+++ mtd-utils-1.5.1/tests/ubi-tests/integ.c
@@ -1,5 +1,10 @@
 #define _LARGEFILE64_SOURCE
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <fcntl.h>
Index: mtd-utils-1.5.1/ubi-utils/libubi.c
===================================================================
--- mtd-utils-1.5.1.orig/ubi-utils/libubi.c
+++ mtd-utils-1.5.1/ubi-utils/libubi.c
@@ -22,6 +22,11 @@
 
 #define PROGRAM_NAME "libubi"
 
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/sysmacros.h>
+
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
