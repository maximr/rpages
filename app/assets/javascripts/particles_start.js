function loadParticlesJS() { 
  particlesJS("particles-js", {
     "particles": {
      "number": {
        "value": 13,
        "density": {
          "enable": true,
          "value_area": 800
        }
      },
      "color": {
        "value": "#54a3f3"
      },
      "shape": {
        "type": "edge",
        "stroke": {
          "width": 0,
          "color": "#54a3f3"
        },
        "polygon": {
          "nb_sides": 4
        }
      },
      "opacity": {
        "value": 0.8,
        "random": false,
        "anim": {
          "enable": false,
          "speed": 1,
          "opacity_min": 0.1,
          "sync": false
        }
      },
      "size": {
        "value": 3,
        "random": true,
        "anim": {
          "enable": false,
          "speed": 40,
          "size_min": 0.1,
          "sync": false
        }
      },
      "line_linked": {
        "enable": true,
        "distance": 350,
        "color": "#54a3f3",
        "opacity": 0.5,
        "width": 0.47
      },
      "move": {
        "enable": true,
        "speed": 3.206824121731046,
        "direction": "none",
        "random": false,
        "straight": false,
        "out_mode": "out",
        "bounce": false,
        "attract": {
          "enable": false,
          "rotateX": 600,
          "rotateY": 1200
        }
      }
    },
    "interactivity": {
      "detect_on": "canvas",
      "events": {
        "onhover": {
          "enable": false,
          "mode": "repulse"
        },
        "onclick": {
          "enable": false,
          "mode": "push"
        },
        "resize": true
      },
      "modes": {
        "grab": {
          "distance": 400,
          "line_linked": {
            "opacity": 1
          }
        },
        "bubble": {
          "distance": 400,
          "size": 40,
          "duration": 2,
          "opacity": 8,
          "speed": 3
        },
        "repulse": {
          "distance": 200,
          "duration": 0.4
        },
        "push": {
          "particles_nb": 4
        },
        "remove": {
          "particles_nb": 2
        }
      }
    },
    "retina_detect": true
  });

  onScrollBy($('.particle_container'), 'down', 25, function() { pJSDom[0].pJS.particles.move.enable = true; pJSDom[0].pJS.fn.particlesRefresh(); });
  onScrollBy($('.intro_container'), 'up', 10, function() { pJSDom[0].pJS.particles.move.enable = false; });
}