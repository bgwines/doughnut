
$TORUS_OUTER_RADIUS = 40;
$TORUS_INNER_RADIUS = 20;
$N_SPRINKLES = 50;
$MESH_FACTOR = 10;
$CIRCLE_RADIUS = ($TORUS_OUTER_RADIUS - $TORUS_INNER_RADIUS) / 2;
$SPRINKLE_COLORS = ["orange", "yellow", "pink", "skyblue"];
$RANDOM_SEED_VALUE = 6000;

module sprinkle(x, y, z) {
  color($SPRINKLE_COLORS[rands(0,4,1)[0]])
    translate([x, y, z])
    rotate(rands(0,360,3))
    translate([0,0,-3/2])
    union() {
      linear_extrude(3) {
        circle(1, $fn=$MESH_FACTOR);
      }
      sphere(1, $fn=$MESH_FACTOR);
      translate([0,0,3])
        sphere(1, $fn=$MESH_FACTOR);
    }
}

function sprinkle_z(rho) = sqrt($CIRCLE_RADIUS^2 -
                             ($CIRCLE_RADIUS + $TORUS_INNER_RADIUS - rho)^2
                                );

module sprinkles() {
  all_rhos = rands($TORUS_INNER_RADIUS,$TORUS_OUTER_RADIUS,$N_SPRINKLES);
  all_thetas = rands(0,360,$N_SPRINKLES);

  for (i = [0:$N_SPRINKLES - 1]) {
    rho = all_rhos[i];
    theta = all_thetas[i];
    x = rho * cos(theta);
    y = rho * sin(theta);
    z = sprinkle_z(rho);
    sprinkle(x, y, z);
  }
}

module torus() {
  rotate_extrude(angle=360, $fn=$MESH_FACTOR)
    translate([$TORUS_INNER_RADIUS + $CIRCLE_RADIUS,0,0])
    circle($CIRCLE_RADIUS, $fn=$MESH_FACTOR);
}

module doughnut() {
  torus();
  sprinkles();
}

doughnut();
