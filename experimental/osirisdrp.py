# import the IFS simulator code
import osiris as osirissim

def simulate_detector_image(cube, band, scale, date):
    "given a data cube reduced by the DRP, simulate a detector image"

    # get the simulator instance
    sim = \
        osirissim.OSIRISSimulator(*osirissim.get_simulator_args(date,
                                                                band,
                                                                scale))

    # (un)flip the cube in y direction if on Keck I

    # simulate the detector image
    im = sim.simulate_IFS_imge(cube, multiprocess=True)

    # glitch creation
    # im = glitch_create(im)

    return im
