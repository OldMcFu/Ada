#ifndef STREAMS_H
#define STREAMS_H

#include <stddef.h> // Für size_t

// Typdefinition des Array-Typs
typedef struct {
    char* data;
    size_t length;
} Stream_Element_Array;

// Deklaration der Funktionen
void initialize_Stream_Element_Array(Stream_Element_Array* array, size_t length);
void cleanup_Stream_Element_Array(Stream_Element_Array* array);

#endif /* STREAMS_H */
