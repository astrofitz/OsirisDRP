# import the IFS simulator code
import osiris as osirissim

def simulate_detector_image(cube, band, scale, date):
    "given a data cube reduced by the DRP, simulate a detector image"

    # get MJD from date string
    from astropy.time import Time
    t = Time("20{}-{}-{}".format(date[0:2], date[2:4], date[4:6]))
    mjd = t.mjd

    # get the simulator instance
    sim = \
        osirissim.OSIRISSimulator(*osirissim.get_simulator_args(date,
                                                                band,
                                                                scale))

    # (un)flip the cube in y direction if on Keck I
    if mjd > 55942.5:
        cube = cube[::-1,:,:]

    # simulate the detector image
    im = sim.simulate_IFS_imge(cube, multiprocess=True)

    # glitch creation
    if (mjd >= 55831.5) & (mjd < 57388.0):
         im = osirissim.glitch_create(im)

    return im
