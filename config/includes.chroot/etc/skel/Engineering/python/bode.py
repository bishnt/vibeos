import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# RC low-pass: R = 1 kOhm, C = 100 nF, so tau = 100 microseconds
tau = 1e3 * 100e-9
G = signal.TransferFunction([1], [tau, 1])
w, mag, phase = signal.bode(G, w=np.logspace(1, 6, 400))
f = w / (2 * np.pi)

fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
ax1.semilogx(f, mag)
ax1.set_ylabel("Gain (dB)")
ax1.grid(True, which="both")
ax2.semilogx(f, phase)
ax2.set_ylabel("Phase (deg)")
ax2.set_xlabel("Frequency (Hz)")
ax2.grid(True, which="both")
plt.show()
