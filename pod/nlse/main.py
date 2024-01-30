import numpy as np
from scipy.integrate import complex_ode
from scipy.fft import fft, ifft
import matplotlib.pyplot as plt
from matplotlib import cm

# Parameters
L = 30
n = 512
x = np.linspace(-L/2, L/2, n+1)[:-1]
k = (2*np.pi/L) * np.concatenate((np.arange(0, n/2), np.arange(-n/2, 0)))
t = np.linspace(0, 2*np.pi, 256)

# Initial condition
u0 = 2 / np.cosh(x)
ut = fft(u0)

# Nonlinear Schrödinger equation (NLS) RHS
def nls_rhs(t, ut, k):
    u = ifft(ut)
    return -(1j/2) * (k**2) * ut + 1j * fft(np.abs(u)**2 * u)

# Solve NLS
solver = complex_ode(lambda t, ut: nls_rhs(t, ut, k))
solver.set_initial_value(ut, t[0])
utsol = [ut]
for ti in t[1:]:
    solver.integrate(ti)
    utsol.append(solver.y)

utsol = np.array(utsol)
usol = ifft(utsol, axis=1)
usol = usol.T

# SVD
u, s, v = np.linalg.svd(usol)

# Plot singular values

# Plot first three modes and dynamics
fig, axs = plt.subplots(2, 1, figsize=(10, 10))
for i in range(3):
    axs[0].plot(x, u[:, i].real)
    axs[1].plot(t, v.T[:, i].real)
axs[0].set_title("Modes")
axs[0].set_xlabel("x")
axs[1].set_title("Dynamics")
axs[1].set_xlabel("t")
fig.savefig("modes-dynamics.png")
plt.close(fig)

# Low-rank approximation
r = 4
phi = u[:, :r]
k2_column = (k**2)[:, np.newaxis]  # Reshape k for broadcasting
phixx = -ifft(k2_column * fft(phi, axis=0), axis=0)
a0 = u0 @ np.conj(phi)
Lr = (1j/2) * phi.T @ phixx

# Low-rank RHS
def a_rhs(t, a, phi, Lr):
    return Lr @ a + 1j * phi.T @ (np.abs(phi @ a)**2 * (phi @ a))

# Solve low-rank system
solver = complex_ode(lambda t, a: a_rhs(t, a, phi, Lr))
solver.set_initial_value(a0, t[0])
asol = [a0]
for ti in t[1:]:
    solver.integrate(ti)
    asol.append(solver.y)

asol = np.array(asol)
usol_low_rank = np.zeros((n, len(t)), dtype=complex)
for j in range(len(t)):
    for jj in range(r):
        usol_low_rank[:, j] += asol[j, jj] * phi[:, jj]

# Plot solutions
fig, axs = plt.subplots(1, 2, figsize=(15, 10))
pos_0 = axs[0].pcolor(t, x, abs(usol))
axs[0].set_title("Original abs val")
pos_1 = axs[1].pcolor(t, x, abs(usol_low_rank))
axs[1].set_title("Reconstructed abs val")
for ax in axs.flat:
    ax.set(xlabel='x', ylabel='t')
fig.colorbar(pos_0, ax=axs[0])
fig.colorbar(pos_1, ax=axs[1])
fig.savefig("nls-solution-abs.png")
plt.close(fig)

# Plot difference |u - u'| / |u|
rel_enegr_diff = abs(usol - usol_low_rank) / abs(usol)

fig, axs = plt.subplots(1, 2, figsize=(15, 10))
pos_0 = axs[0].pcolor(t, x, rel_enegr_diff)
axs[0].set_title("Rel diff abs val")
pos_1 = axs[1].pcolor(t, x, np.log(rel_enegr_diff))
axs[1].set_title("Log")
fig.colorbar(pos_0, ax=axs[0])
fig.colorbar(pos_1, ax=axs[1])
fig.savefig("diff-abs.png")
plt.close(fig)

# fig, ax = plt.subplots()
# ax.plot(s, "o")
# ax.set_yscale('log')
# fig.savefig("singular-values.png")
# plt.close(fig)
#
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# ax.plot_surface(X, T, np.abs(usol_low_rank.T), cmap=cm.hot)
# fig.savefig("nls-solution-low-rank.png")
# plt.close(fig)
