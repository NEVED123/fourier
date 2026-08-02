import "dart:math" as m;

double fourier(double Function(double) g, double f) {
  const double RESOLUTION = 1000;
  Complex Function(double) g_complex = (double t) => Complex(r: g(t));

  Complex integral = complexIntegral(-RESOLUTION, RESOLUTION, (double t) {
    return g_complex(t) * Complex.pow(m.e, Complex(i: -2 * m.pi * f * t));
  });

  return Complex.magnitude(integral);
}

Complex complexIntegral(double t1, double t2, Complex Function(double) f) {
  Complex integral_result = Complex();
  const double N = 1000;
  double delta_t = (t2 - t1) / N;

  for (double j = 1; j <= N; j++) {
    integral_result += f(t1 + delta_t * j) * Complex(r: delta_t);
  }

  return integral_result;
}

class Complex {
  num r;
  num i;

  Complex({this.r = 0, this.i = 0});

  Complex operator *(Complex other) {
    num real = this.r * other.r - this.i * other.i;
    num imaginary = this.r * other.i + other.r * this.i;
    return Complex(r: real, i: imaginary);
  }

  Complex operator +(Complex other) {
    return Complex(r: this.r + other.r, i: this.i + other.i);
  }

  // Complex operator /(Complex other) {
  //   num real =
  //       (this.r * other.r + this.i * other.i) /
  //       (m.pow(other.r, 2) + m.pow(other.i, 2));
  //   num imaginary =
  //       (this.i * other.r - this.r * other.i) /
  //       (m.pow(other.r, 2) + m.pow(other.i, 2));
  //   return Complex(r: real, i: imaginary);
  // }

  static Complex pow(num base, Complex expo) {
    num real = m.pow(base, expo.r) * m.cos(expo.i * m.log(base));
    num imaginary = m.sin(expo.i * m.log(base));
    return Complex(r: real, i: imaginary);
  }

  static double magnitude(Complex n) {
    return m.sqrt(m.pow(n.r, 2) + m.pow(n.i, 2));
  }

  @override
  String toString() {
    String output = '';
    if (r == 0 && i == 0) {
      output += '0';
    }
    if (r != 0) {
      output += r.toString();
    }
    if (i != 0) {
      output += ' + ${i}i';
    }
    return output;
  }
}

main() {
  for (double f = 0; f < 6; f += .1) {
    print('f: $f, ${fourier((double t) => m.sin(m.pi * t), f)}');
  }
}
