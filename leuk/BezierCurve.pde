class BezierCurve {
  
  private final int SEGMENT_COUNT = 100;
  
  private PVector v0, v1, v2, v3;
  
  private float arcLengths[] = new float[SEGMENT_COUNT + 1]; // there are n segments between n+1 points
  
  private float curveLength;
  
  
  BezierCurve(PVector a, PVector b, PVector c, PVector d) {
    v0 = a.get(); // curve begins here
    v1 = b.get();
    v2 = c.get();
    v3 = d.get(); 
    
    float arcLength = 0;
    
    PVector prev = new PVector();
    prev.set(v0);
    
    // i goes from 0 to SEGMENT_COUNT
    for (int i = 0; i <= SEGMENT_COUNT; i++) {
      
      float t = (float) i / SEGMENT_COUNT;
      
      PVector point = pointAtParameter(t);
      
      float distanceFromPrev = PVector.dist(prev, point);
      
      arcLength += distanceFromPrev;
      
      arcLengths[i] = arcLength;
      
      prev.set(point);
    }
    
    curveLength = arcLength;
  }
  

  float length() {
    return curveLength;
  }
  

  PVector pointAtParameter(float t) {
    PVector result = new PVector();
    result.x = bezierPoint(v0.x, v1.x, v2.x, v3.x, t);
    result.y = bezierPoint(v0.y, v1.y, v2.y, v3.y, t);
    result.z = bezierPoint(v0.z, v1.z, v2.z, v3.z, t);
    return result;
  }

  

  PVector pointAtFraction(float r) {
    float wantedLength = curveLength * r;
    return pointAtLength(wantedLength);
  }
  
  
  PVector pointAtLength(float wantedLength) {
    wantedLength = constrain(wantedLength, 0.0, curveLength);
    
    int index = java.util.Arrays.binarySearch(arcLengths, wantedLength);
    
    float mappedIndex;
    
    if (index < 0) {
      int nextIndex = -(index + 1);
      int prevIndex = nextIndex - 1;
      float prevLength = arcLengths[prevIndex];
      float nextLength = arcLengths[nextIndex];
      mappedIndex = map(wantedLength, prevLength, nextLength, prevIndex, nextIndex);
      
    } else {
      mappedIndex = index;
    }
    
    float parameter = mappedIndex / SEGMENT_COUNT;
    
    return pointAtParameter(parameter);
  }
  

  PVector[] equidistantPoints(int howMany) {
    
    PVector[] resultPoints = new PVector[howMany];
    
    resultPoints[0] = v0.get();
    resultPoints[howMany - 1] = v3.get(); 
    
    int arcLengthIndex = 1;
    for (int i = 1; i < howMany - 1; i++) {
      
      float fraction = (float) i / (howMany - 1);
      float wantedLength = fraction * curveLength;

      while (wantedLength > arcLengths[arcLengthIndex] && arcLengthIndex < arcLengths.length) {
        arcLengthIndex++;
      }
      
      int nextIndex = arcLengthIndex;
      int prevIndex = arcLengthIndex - 1;
      float prevLength = arcLengths[prevIndex];
      float nextLength = arcLengths[nextIndex];
      float mappedIndex = map(wantedLength, prevLength, nextLength, prevIndex, nextIndex);
      
      float parameter = mappedIndex / SEGMENT_COUNT;
      
      resultPoints[i] = pointAtParameter(parameter);
    }
    
    return resultPoints;
  }
  
  
  PVector[] points(int howMany) {
    
    PVector[] resultPoints = new PVector[howMany];
    
    resultPoints[0] = v0.get();
    resultPoints[howMany - 1] = v3.get();
    
    for (int i = 1; i < howMany - 1; i++) {
      
      float parameter = (float) i / (howMany - 1);
      
      resultPoints[i] = pointAtParameter(parameter);
    }
    
    return resultPoints;
  }
  
}