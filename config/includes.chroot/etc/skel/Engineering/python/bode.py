import control as ct
import matplotlib.pyplot as plt

# RC low-pass: R = 1 kOhm, C = 100 nF, so tau = 100 microseconds
G = ct.tf([1], [1e-4, 1])
ct.bode_plot(G, dB=True)
plt.show()
