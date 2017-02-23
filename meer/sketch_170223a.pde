float[] xs;

void setup()
{
  size(1400, 750);
  xs = new float[100];
  for (int i=0; i<100; ++i)
  {
    xs[i] = i * 6;
  }
}

void draw()
{
  for (int i=0; i<100; ++i)
  {
    fill(90,123,54);
    ellipse(xs[i],75,50,50);
    xs[i] = xs[i] + 1;
    if (xs[i] > 625)
    {
      xs[i] = -25;
    }
  }
}