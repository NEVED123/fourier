import "dart:math" as m;

num fourier(num Function(num) g, num f) {
  const int RESOLUTION = 100;

  Complex integral = complexIntegral(-RESOLUTION, RESOLUTION, (num t) {
    return Complex(r: g(t)) * Complex.pow(m.e, Complex(i: -2 * m.pi * f * t));
  });

  return Complex.magnitude(integral);
}

// Currently works iff samples.length is a power of 2
List<Complex> fft(List<num> samples) {
  int N = samples.length;
  if (N == 1) {
    return [Complex(r: samples[0])];
  }

  int M = N ~/ 2;
  List<num> evenSamples = List.filled(M, 0);
  List<num> oddSamples = List.filled(M, 0);

  for (int i = 0; i < M; i += 1) {
    evenSamples[i] = samples[i * 2];
    oddSamples[i] = samples[i * 2 + 1];
  }

  List<Complex> evenF = fft(evenSamples);
  List<Complex> oddF = fft(oddSamples);

  List<Complex> freqBins = List.filled(N, Complex());

  for (int k = 0; k < M; k++) {
    Complex exponential =
        Complex.pow(m.e, Complex(i: -2 * m.pi * k / N)) * oddF[k];
    freqBins[k] = evenF[k] + exponential;
    freqBins[k + M] = evenF[k] - exponential;
  }

  return freqBins;
}

List<num> normalizeFft(List<Complex> fftOutput) {
  return List.generate(
    fftOutput.length ~/ 2,
    (k) => Complex.magnitude(fftOutput[k] * Complex(r: 2)),
  );
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

  Complex operator -(Complex other) {
    return Complex(r: this.r - other.r, i: this.i - other.i);
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

Function(double t) sinWaveHz(double hz) {
  return (t) => m.sin(t * 2 * m.pi * hz);
}

main() {
  int samplingFreq = 1024;
  List<double> sinDatapoints = List.generate(
    samplingFreq,
    (t) => sinWaveHz(1)(t / samplingFreq),
  );
  print(normalizeFft(fft(sinDatapoints)));
}
