import "dart:math" as m;

num fourier(num Function(num) g, num f) {
  const int RESOLUTION = 100;

  Complex integral = complexIntegral(-RESOLUTION, RESOLUTION, (num t) {
    return Complex(r: g(t)) * Complex.pow(m.e, Complex(i: -2 * m.pi * f * t));
  });

  return Complex.magnitude(integral);
}

Complex complexIntegral(num t1, num t2, Complex Function(num) f) {
  Complex integral_result = Complex();
  const int N = 10000;
  double delta_t = (t2 - t1) / N;

  for (int j = 1; j <= N; j++) {
    integral_result += f(t1 + delta_t * j);
  }

  return integral_result * Complex(r: delta_t);
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
  int target_hertz = 20;
  for (int h = target_hertz - 5; h < target_hertz + 6; h += 1) {
    print(
      'h: $h, ${fourier((num t) => m.sin(target_hertz * 2 * m.pi * t), h)}',
    );
  }
}
