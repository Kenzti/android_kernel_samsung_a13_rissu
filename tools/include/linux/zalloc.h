/* SPDX-License-Identifier: GPL-2.0 */
#ifndef __TOOLS_LINUX_ZALLOC_H
#define __TOOLS_LINUX_ZALLOC_H

#include <stdlib.h>
#include <string.h>

static inline void *zalloc(size_t size)
{
	return calloc(1, size);
}

static inline void zfree(void **ptr)
{
	free(*ptr);
	*ptr = NULL;
}

#endif /* __TOOLS_LINUX_ZALLOC_H */
