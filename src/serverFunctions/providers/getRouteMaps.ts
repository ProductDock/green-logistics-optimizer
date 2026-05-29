/**
 * @polyapi.function
 * Simulated Mapping and Route Matrix Provider
 */
export async function getRouteMaps(origin: string, destination: string) {
  console.log("Get Route", new Date().toUTCString());
  
  return {
    code: "Ok",
    durations: [[37800]], 
    distances: [[1052000]], 
    units: {
      duration: "seconds",
      distance: "meters"
    },
    route_summary: "A2 / A36 via Frankfurt and Mulhouse"
  };
}