/*
 * glue-logic for mpf_t
 */
#include <gmp.h>
#include <stdlib.h>

extern void pony_error();

mpf_t*
pony_mpf_init() {
  mpf_t* f = (mpf_t*)malloc(sizeof(mpf_t));
  if (f == NULL) {
    pony_error();
  }
  mpf_init(*f);
  return f;
}

void
pony_mpf_clear(void* f) {
  if (f) {
    mpf_clear(*(mpf_t*)f);
    free(f);
  }
}

void*
pony_mpf_init_set_ui(unsigned long int i) {
  mpf_t* f = (mpf_t*)malloc(sizeof(mpf_t));
  if (f == NULL) {
    pony_error();
  }
  mpf_init_set_ui(*(mpf_t*)f, i);
  return f;
}

void*
pony_mpf_init_set_si(signed long int i) {
  mpf_t *f = (mpf_t*)malloc(sizeof(mpf_t));
  if (f == NULL) {
    pony_error();
  }
  mpf_init_set_si(*(mpf_t*)f, i);
  return f;
}

void*
pony_mpf_init_set_d(double d) {
  mpf_t *f = (mpf_t*)malloc(sizeof(mpf_t));
  if (f == NULL) {
    pony_error();
  }
  mpf_init_set_d(*(mpf_t*)f, d);
  return f;
}

void*
pony_mpf_init_set_z(void * z) {
  mpf_t* f = pony_mpf_init();
  mpf_set_z(*(mpf_t*)f, *(mpz_t*)z);
  return f;
}

void*
pony_mpf_init_set_str(const char* s, int base) {
  mpf_t* f = (mpf_t*)malloc(sizeof(mpf_t));
  if (f == NULL) {
    pony_error();
  }
  mpf_init_set_str(*(mpf_t*)f, s, base);
  return f;
}

signed long int pony_mpf_get_si(void* f) {
  if (f == NULL) {
    pony_error();
  }
  return mpf_get_si(*(mpf_t*)f);
}

unsigned long int pony_mpf_get_ui(void* f) {
  if (f == NULL) {
    pony_error();
  }
  return mpf_get_ui(*(mpf_t*)f);
}

double pony_mpf_get_d(void* f) {
  if (f == NULL) {
    pony_error();
  }
  return mpf_get_d(*(mpf_t*)f);
}

void
pony_mpf_add(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpf_add(*(mpf_t*)r, *(mpf_t*)a, *(mpf_t*)b);
}

void
pony_mpf_sub(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpf_sub(*(mpf_t*)r, *(mpf_t*)a, *(mpf_t*)b);
}

void
pony_mpf_mul(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpf_mul(*(mpf_t*)r, *(mpf_t*)a, *(mpf_t*)b);
}

void
pony_mpf_div(void* r, void* a, void* b) {
  if (r == NULL || a == NULL || b == NULL) {
    pony_error();
  }
  mpf_div(*(mpf_t*)r, *(mpf_t*)a, *(mpf_t*)b);
}
void
pony_mpf_sqrt(void* r, void* f) {
  if (r == NULL || f == NULL) {
    pony_error();
  }
  mpf_sqrt(*(mpf_t*)r, *(mpf_t*)f);
}
int
pony_mpf_cmp(void* a, void* b) {
  if (a == NULL || b == NULL) {
    pony_error();
  }
  return mpf_cmp(*(mpf_t*)a, *(mpf_t*)b);
}

char*
pony_mpf_snprintf(char* buf, size_t size, const char* format, void* f) {
  if (buf == NULL || f == NULL) {
    pony_error();
  }
  gmp_snprintf(buf, size, format, *(mpf_t*)f);
  return buf;
}
