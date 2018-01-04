/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

class Disease {
   constructor(lat, long, name, date_sick, date_healthy) {
    this.lat = parseFloat(lat);
    this.long = parseFloat(long);
    this.name = name;
    this.date_sick = new Date(date_sick);
    this.date_healthy = date_healthy.replace('"','');
    this.date_healthy = this.date_healthy.replace('"','');
    this.date_healthy = new Date(this.date_healthy);    
    this.today = new Date();
  }
  // Getter
  get active() {
    return this.isActive();
  }
  // Method
  isActive() {
    return this.today > this.date_sick && this.today < this.date_healthy;
  }
  
  get string() {
      return this.toString();
  }
  
  toString() {
      return this.lat.toString() + " " + this.long.toString() + " " + this.name
      + " " + this.date_sick + " " + this.date_healthy + " " + this.today;
  }
}