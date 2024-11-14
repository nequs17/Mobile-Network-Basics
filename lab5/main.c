#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <x86intrin.h>

#define DATA_LENGTH_1 21
#define DATA_LENGTH_2 250
#define DATA_LENGTH_3 282
#define DATA_LENGTH_256 256
#define CRC_LENGTH_8bit 3
#define CRC_LENGTH_32bit 8

#define POLY 0xBF

const uint8_t crc_poly_8bit = 0xBF;

const uint32_t crc_poly_32bit = 0x04C11DB7; // IEEE 802.3

uint8_t crc8_table[DATA_LENGTH_256];


uint8_t calculate_crc_8(const uint8_t *data,size_t length){
    uint8_t crc = 0;
    for (size_t i = 0; i < length; i++)
    {
        crc ^= data[i];
        for (size_t j = 0; j < 8; j++)
        {
            if (crc & 0x80){
                crc = (crc << 1) ^ crc_poly_8bit;
            }else{
                crc <<= 1;
            }
        }
        
    }
    return crc;
}

int check_crc_8(uint8_t *data, size_t length, uint8_t received_crc) {return calculate_crc_8(data, length) == received_crc; }

uint32_t calculate_crc_32(const uint8_t *data,size_t length){
    uint32_t crc = 0;              
    for (int i = 0; i < length; i++) {
        crc ^= (uint32_t)data[i] << 24;
        for (int j = 0; j < 8; j++) {
            if (crc & 0x80000000)        
                crc = (crc << 1) ^ crc_poly_32bit;
            else
                crc <<= 1;
        }
    }
    return crc;
}

int check_crc_32(uint8_t *data, size_t length, uint8_t received_crc) { return received_crc == calculate_crc_32(data, length); }

void init_crc8_table(){
    for (int i = 0; i < DATA_LENGTH_256; i++) {
        uint8_t crc = i;
        for (int j = 0; j < 8; j++) {
            if (crc & 0x80)       
                crc = (crc << 1) ^ crc_poly_8bit;
            else
                crc <<= 1;
        }
        crc8_table[i] = crc;
    }

}

uint8_t calculate_crc8_table(uint8_t *data, size_t length) {
    uint8_t crc = 0;
    for (int i = 0; i < length; i++) {
        uint8_t table_index = crc ^ data[i];
        crc = crc8_table[table_index];
    }
    return crc;
}

int main(){
    uint8_t data[DATA_LENGTH_2 / 8] = {0};

    for (int i = 0; i < DATA_LENGTH_2 / 8; i++) {
        data[i] = 0xFF;
    }

    printf("CRC 8 bits:\n");

    double start_crc8 = __rdtsc();

    uint8_t crc_8bit = calculate_crc_8(data,DATA_LENGTH_2 / 8);

    double end_crc8 = __rdtsc();

    printf("crc: 0x%02X\n",crc_8bit);


    printf("Tacts for crc8: %f\n",end_crc8-start_crc8);

    if (check_crc_8(data, DATA_LENGTH_2 / 8, crc_8bit)) {
        printf("Пакет принят без ошибок.\n");
    } else {
        printf("Обнаружена ошибка в принятом пакете.\n");
    }

    uint8_t data_crc32[DATA_LENGTH_256 / 8] = {0};

    for (int i = 0; i < DATA_LENGTH_256 / 8; i++) {
        data_crc32[i] = 0xFF;
    }

    int error_detected_8bit = 0;
    int error_not_detected_8bit = 0;

    for (int i = 0; i < DATA_LENGTH_2; i++) {
        data[i / 8] ^= (1 << (7 - (i % 8)));

        if (!check_crc_8(data, DATA_LENGTH_2 / 8, crc_8bit)) {
            error_detected_8bit++;
        } else {
            error_not_detected_8bit++;
        }

        data[i / 8] ^= (1 << (7 - (i % 8)));
    }

    printf("Error: %d\n", error_detected_8bit);
    printf("Without error: %d\n", error_not_detected_8bit);

    printf("\nFast CRC-8:\n");

    init_crc8_table();

    start_crc8 = __rdtsc();

    uint8_t crc_8bit_table = calculate_crc8_table(data_crc32,DATA_LENGTH_256 / 8);

    end_crc8 = __rdtsc();

    printf("crc: 0x%02X\n",crc_8bit);

    printf("Tacts for crc8 table: %f\n",end_crc8-start_crc8);

    printf("\n\nCRC 32 bits:\n");

    uint32_t crc_32bit = calculate_crc_32(data_crc32,DATA_LENGTH_256 / 8);
    printf("crc: 0x%02X\n",crc_32bit);

    int error_detected_32bit = 0;
    int error_not_detected_32bit = 0;

    for (int i = 0; i < DATA_LENGTH_256; i++) {
        data_crc32[i / 8] ^= (1 << (7 - (i % 8)));

        if (!check_crc_32(data_crc32, DATA_LENGTH_256 / 8, crc_32bit)) {
            error_detected_32bit++;
        } else {
            error_not_detected_32bit++;
        }

        data_crc32[i / 8] ^= (1 << (7 - (i % 8)));
    }

    printf("Error: %d\n", error_detected_32bit);
    printf("Without error: %d\n", error_not_detected_32bit);

    return 0;
}