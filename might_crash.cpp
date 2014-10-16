#include <cstdlib>

int main() {
  if( getenv("CRASH_PLEASE") ) {
      // this will crash
      delete (int*)0xffffffff;    
  } 
}