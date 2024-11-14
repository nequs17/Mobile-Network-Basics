#include <stdio.h>
#include <stdint.h>

#define POLYNOMIAL_32 0x04C11DB7     // Полином для CRC-32
#define DATA_LENGTH 256              // Длина данных в битах (250 бит -> 32 байта)
#define CRC_LENGTH 32                // Длина CRC в битах для CRC-32

// Функция для вычисления 32-битного CRC
uint32_t calculate_crc32(uint8_t *data, int length) {
    uint32_t crc = 0;               // CRC инициализировано нулем
    for (int i = 0; i < length; i++) {
        crc ^= (uint32_t)data[i] << 24;  // XOR текущего байта (выравниваем по старшему разряду)
        for (int j = 0; j < 8; j++) {
            if (crc & 0x80000000)        // Проверка старшего бита
                crc = (crc << 1) ^ POLYNOMIAL_32;
            else
                crc <<= 1;
        }
    }
    return crc;                     // Оставляем без инверсии
}

// Функция для проверки принятого пакета на наличие ошибок
int check_crc32(uint8_t *data, int length, uint32_t received_crc) {
    uint32_t calculated_crc = calculate_crc32(data, length);
    return calculate_crc32(data, length) == received_crc; // Ошибки нет, если CRC совпадает
}

int main() {
    uint8_t data[DATA_LENGTH / 8] = {0};  // Исходный пакет данных (250 бит -> 32 байта)
    
    // Генерация данных для тестирования (заполняем единицами)
    for (int i = 0; i < DATA_LENGTH / 8; i++) {
        data[i] = 0xFF;
    }
    
    // Вычисляем CRC-32 для данных
    uint32_t crc32 = calculate_crc32(data, DATA_LENGTH / 8);
    printf("Вычисленное значение CRC-32: 0x%X\n", crc32);

    // Проверка на приемной стороне без искажений
    if (check_crc32(data, DATA_LENGTH / 8, crc32)) {
        printf("Пакет принят без ошибок.\n");
    } else {
        printf("Обнаружена ошибка в принятом пакете.\n");
    }

    // Цикл для проверки на искажение по каждому биту
    int error_detected = 0;
    int error_not_detected = 0;
    for (int i = 0; i < DATA_LENGTH; i++) {  // Искажаем только биты данных
        // Искажаем i-й бит данных
        data[i / 8] ^= (1 << (7 - (i % 8)));

        // Проверка искаженного пакета
        if (!check_crc32(data, DATA_LENGTH / 8, crc32)) {
          error_detected++;
        } else {
            error_not_detected++;
            printf("Не обнаружена ошибка при искажении бита: %d\n", i);
        }


        // Возвращаем бит обратно
        data[i / 8] ^= (1 << (7 - (i % 8)));
    }

    printf("Обнаружено ошибок: %d\n", error_detected);
    printf("Не обнаружено ошибок: %d\n", error_not_detected);

    return 0;
}
