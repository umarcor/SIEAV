/*
 * File:   motorsim.c
 * Author: Koldo Basterretxea
 *
 * Created on 15 de abril de 2020, 12:51
 */

// Motor

const float c[] = {0.35003, 0.062554};
const float d[] = {-0.84659, 0.00183};

float v[] = {0, 0};
float th[] = {0, 0};

volatile float Motor(float vk) {
    float thk = (c[0]*v[0]) + (c[1]*v[1]) - (d[0]*th[0]) - (d[1]*th[1]); // abiadura ardatzean rad/sec

    v[1]=v[0];
    v[0]=vk;
    th[1]=th[0];
    th[0]=thk;

    return thk*9.549297; // rad/sec to rpm
}

// Controller

const float b[] = {0.005455, 0.003455};
const float a = -1;

volatile float uk = 0;
float uk1 = 0;
float ek1 = 0;;

volatile float Controller(float ek) {
  uk = (b[0]*ek) + (b[1]*ek1) - (a*uk);
  if (uk > 6) {
    uk=6;
  }

  uk1=uk;
  ek1=ek;

  return uk;
}
