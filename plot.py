#!/usr/bin/python3

import matplotlib.pyplot as plt


def main():
	# TODO: for each compression level in {0, 1, ..., 9}:
	#			fill real_time [ms]
	#			fill archive_size [bytes]
	level        = list(range(10))
	real_time    = [0.005,0.017,0.020,0.029,0.024,0.038,0.065,0.098,0.190,0.205]
	archive_size = [1440218,331253,310248,285757,255569,240879,231742,229192,227524,227390]

	archive_size = [it / 1024 for it in archive_size]

	# plot data
	fix, axs = plt.subplots(2)

	axs[0].plot(level, real_time,    'bo-')
	axs[1].plot(level, archive_size, 'ro-')

	axs[0].set_xticks(level)
	axs[1].set_xticks(level)

	axs[0].grid(True, which='both')
	axs[1].grid(True, which='both')

	axs[0].set_xlabel('Compression level')
	axs[1].set_xlabel('Compression level')

	axs[0].set_ylabel('Time [ms]')
	axs[1].set_ylabel('Archive size [byte]')

	plt.show()


if __name__ == '__main__':
	main()