/**
 * @file mem_utils.c
 *
 * Memory utilities implementation
 *
 * @author: German Rivera
 */

#include "mem_utils.h"

#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"

#define HOW_MANY(_m, _n)    (((uintptr_t)(_m) - 1) / (_n) + 1)

#define ROUND_UP(_m, _n)    (HOW_MANY(_m, _n) * (_n))

#define ROUND_DOWN(_m, _n)    (((uintptr_t)(_m) / (_n)) * (_n))

/**
 * Copies a 32-bit aligned block of memory from one location to another
 *
 * @param src: pointer to source location
 * @param dst: pointer to destination location
 * @param size: size in bytes
 *
 * @pre dst must be a 4-byte aligned address
 * @pre src must be a 4-byte aligned address
 * @pre size must be a multiple of 4
 */
static inline void memcpy32(uint32_t *dst, const uint32_t *src, size_t size)
{
	register uint32_t *dst_cursor = dst;
	register const uint32_t *src_cursor = src;

	uint32_t num_words = size / sizeof(uint32_t);
	register uint32_t *dst_end = dst + ((num_words / 4) * 4);

	while (dst_cursor != dst_end) {
		dst_cursor[0] = src_cursor[0];
		dst_cursor[1] = src_cursor[1];
		dst_cursor[2] = src_cursor[2];
		dst_cursor[3] = src_cursor[3];
		dst_cursor += 4;
		src_cursor += 4;
	}

	switch (num_words % 4) {
	case 3:
		*dst_cursor++ = *src_cursor++;
	case 2:
		*dst_cursor++ = *src_cursor++;
	case 1:
		*dst_cursor++ = *src_cursor++;
	}
}

void *memcpy(void *dst, const void *src, size_t size)
{
   uint32_t *dst_words = (uint32_t *)ROUND_UP(dst, sizeof(uint32_t));
   uint32_t *src_words = (uint32_t *)ROUND_UP(src, sizeof(uint32_t));
   size_t bytes_before_align = (uintptr_t)dst_words - (uintptr_t)dst;
   size_t bytes_after_align = (size - bytes_before_align) % sizeof(uint32_t);
   size_t aligned_size = size - bytes_before_align - bytes_after_align;

   if (bytes_before_align != 0) {
	uint8_t *dst_bytes = dst;
	const uint8_t *src_bytes = src;

      	switch (bytes_before_align) {
	case 3:
		dst_bytes[0] = src_bytes[0];
	case 2:
		dst_bytes[1] = src_bytes[1];
	case 1:
		dst_bytes[2] = src_bytes[2];
	}
   }

   memcpy32(dst_words, src_words, aligned_size);

   if (bytes_after_align != 0) {
      	uint8_t *dst_bytes = (uint8_t *)dst_words + aligned_size;
	const uint8_t *src_bytes = (uint8_t *)src_words + aligned_size;

      	switch (bytes_after_align) {
	case 3:
		dst_bytes[0] = src_bytes[0];
	case 2:
		dst_bytes[1] = src_bytes[1];
	case 1:
		dst_bytes[2] = src_bytes[2];
	}
   }

   return dst;
}


/**
 * Initializes all bytes of a 32-bit-aligned memory block to a given value
 *
 * @param dst: pointer to destination location
 * @param size: size in bytes
 *
 * @pre dst must be a 4-byte aligned address
 * @pre size must be a multiple of 4
 */
static inline void memset32(uint32_t *dst, uint_fast8_t byte_value,
                            size_t size)
{
	register uint32_t *dst_cursor = dst;
	register uint32_t word_value;

	uint32_t num_words = size / sizeof(uint32_t);
	register uint32_t *dst_end = dst + ((num_words / 4) * 4);

	if (byte_value != 0) {
		word_value = (((uint32_t)byte_value << 24) |
			      ((uint32_t)byte_value << 16) |
			      ((uint32_t)byte_value << 8) |
			      byte_value);
	} else {
		word_value = 0;
	}

	while (dst_cursor != dst_end) {
		dst_cursor[0] = word_value;
		dst_cursor[1] = word_value;
		dst_cursor[2] = word_value;
		dst_cursor[3] = word_value;
		dst_cursor += 4;
	}

	switch (num_words % 4) {
	case 3:
		*dst_cursor++ = word_value;
	case 2:
		*dst_cursor++ = word_value;
	case 1:
		*dst_cursor++ = word_value;
	}
}

void *memset(void *dst, int byte_value, size_t size)
{
   uint32_t *dst_words = (uint32_t *)ROUND_UP(dst, sizeof(uint32_t));
   size_t bytes_before_align = (uintptr_t)dst_words - (uintptr_t)dst;
   size_t bytes_after_align = (size - bytes_before_align) % sizeof(uint32_t);
   size_t aligned_size = size - bytes_before_align - bytes_after_align;

   if (bytes_before_align != 0) {
	uint8_t *dst_bytes = dst;

      	switch (bytes_before_align) {
	case 3:
		dst_bytes[0] = byte_value;
	case 2:
		dst_bytes[1] = byte_value;
	case 1:
		dst_bytes[2] = byte_value;
	}
   }

   memset32(dst_words, byte_value, aligned_size);

   if (bytes_after_align != 0) {
      	uint8_t *dst_bytes = (uint8_t *)dst_words + aligned_size;

      	switch (bytes_after_align) {
	case 3:
		dst_bytes[0] = byte_value;
	case 2:
		dst_bytes[1] = byte_value;
	case 1:
		dst_bytes[2] = byte_value;
	}
   }

   return dst;
}


