import "dart:math";

double fourier(double t1, double t2, double Function(double) g, double f) {
  return integral(t1, t2, (double t) {
    return g(t) * pow(e, -2 * pi * f * t);
  });
}

double integral(double t1, double t2, double Function(double) f) {
  double integral = 0;
  const double resolution = .001;

  for (double i = t1; i <= t2; i += resolution) {
    integral += f(i) / resolution;
  }

  return integral;
}

class Complex {
  double r;
  double i;

  Complex(this.r, this.i);

  Complex operator *(Complex other) {
    return  + 
  }

  Complex operator +(Complex other) {
    return Complex(this.r + other.r, this.i + other.i);
  }
}
