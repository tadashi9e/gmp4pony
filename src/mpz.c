/*
 * glue-logic for mpz_t
 */
#include <gmp.h>
#include <stdlib.h>

extern void pony_error();

mpz_t*
pony_mpz_init() {
  mpz_t* z = (mpz_t*)malloc(sizeof(mpz_t));
  if (z == NULL) {
    pony_error();
  }
  mpz_init(*z);
  return z;
}

void*
pony_mpz_init_set_ui(unsigned long int i) {
  mpz_t *z = (mpz_t*)malloc(sizeof(mpz_t));
  if (z == NULL) {
    pony_error();
  }
  mpz_init_set_ui(*(mpz_t*)z, i);
  return z;
}

void*
pony_mpz_init_set_si(signed long int i) {
  mpz_t *z = (mpz_t*)malloc(sizeof(mpz_t));
  if (z == NULL) {
    pony_error();
  }
  mpz_init_set_si(*(mpz_t*)z, i);
  return z;
}

void*
pony_mpz_init_set_d(double d) {
  mpz_t *z = (mpz_t*)malloc(sizeof(mpz_t));
  if (z == NULL) {
    pony_error();
  }
  mpz_init_set_d(*(mpz_t*)z, d);
  return z;
}

void*
pony_mpz_init_set_f(void* f) {
  if (f == NULL) {
    pony_error();
  }
  mpz_t *z = pony_mpz_init();
  if (z == NULL) {
    pony_error();
  }
  mpz_set_f(*(mpz_t*)z, *(mpf_t*)f);
  return z;
}

void*
pony_mpz_init_set_str(const char* s, int base) {
  mpz_t *z = (mpz_t*)malloc(sizeof(mpz_t));
  if (z == NULL) {
    pony_error();
  }
  mpz_init_set_str(*(mpz_t*)z, s, base);
  return z;
}

void
pony_mpz_clear(void* z) {
  if (z) {
    mpz_clear(*(mpz_t*)z);
    free(z);
  }
}

signed long int pony_mpz_get_si(void* z) {
  if (z == NULL) {
    pony_error();
  }
  return mpz_get_si(*(mpz_t*)z);
}

unsigned long int pony_mpz_get_ui(void* z) {
  if (z == NULL) {
    pony_error();
  }
  return mpz_get_ui(*(mpz_t*)z);
}

double pony_mpz_get_d(void* z) {
  if (z == NULL) {
    pony_error();
  }
  return mpz_get_d(*(mpz_t*)z);
}

void
pony_mpz_add(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_add(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_sub(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_sub(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_mul(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_mul(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_fdiv_q(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_fdiv_q(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_and(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_and(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_ior(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_ior(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

void
pony_mpz_xor(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpz_xor(*(mpz_t*)r, *(mpz_t*)a, *(mpz_t*)b);
}

int
pony_mpz_cmp(void* a, void* b) {
  if (a == NULL || b == NULL) {
    pony_error();
  }
  return mpz_cmp(*(mpz_t*)a, *(mpz_t*)b);
}

size_t
pony_mpz_sizeinbase(void* z, int base) {
  if (z == NULL) {
    pony_error();
  }
  return mpz_sizeinbase(*(mpz_t*)z, base);
}

char*
pony_mpz_snprintf(char* buf, size_t size, const char* format, void* z) {
  if (buf == NULL || z == NULL) {
    pony_error();
  }
  gmp_snprintf(buf, size, format, *(mpz_t*)z);
  return buf;
}
