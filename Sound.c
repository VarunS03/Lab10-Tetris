// Sound.c
// Runs on any TM4C123
// Sound assets based off the original Space Invaders 
// Import these constants into your SpaceInvaders.c for sounds!
// Jonathan Valvano
// 11/15/2021 
#include <stdint.h>
#include "../inc/tm4c123gh6pm.h"
#include "Sound.h"
#include "DAC.h"
#include "Timer0.h"





void Sound_Init(void){
// write this
    // initialize a 11kHz Timer0A, and the DAC
};
/*void Timer0A_Handler(void){ // called at 11 kHz
  TIMER0_ICR_R = 0x01;   // acknowledge TIMER0A timeout
  // output one value to DAC if a sound is active
}
*/
//******* Sound_Start ************
// This function does not output to the DAC. 
// Rather, it sets a pointer and counter, and then enables the timer interrupt.
// It starts the sound, and the timer ISR does the output
// feel free to change the parameters
// Input: pt is a pointer to an array of DAC outputs
//        count is the length of the array
// Output: none
// special cases: as you wish to implement
void Sound_Start(const uint8_t *pt, uint32_t count){
// write this
};
void Sound_Shoot(void){
// write this
};
void Sound_Killed(void){
// write this
};
void Sound_Explosion(void){
// write this
};

void Sound_Fastinvader1(void){
// write this
};
void Sound_Fastinvader2(void){
// write this
};
void Sound_Fastinvader3(void){
// write this
};
void Sound_Fastinvader4(void){
// write this
};
void Sound_Highpitch(void){
// write this
};
