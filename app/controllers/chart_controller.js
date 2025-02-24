import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    document.addEventListener("click", this.handleOutsideClick.bind(this));
    this.addChartClickListener();
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this));
  }

  handleOutsideClick(event) {
    let chartElement = this.element.querySelector(".chart-container");

    if (!chartElement.contains(event.target)) {
      console.log("차트 외부 클릭 감지!");
      alert("차트 외부 클릭!");
    }
  }

  addChartClickListener() {
    // Chartkick이 Chart.js를 사용 중인지 확인
    let chartInstance = Chartkick.charts["myChart"];
    if (chartInstance && chartInstance.chart) {
      chartInstance.chart.canvas.addEventListener("click", (event) => {
        let points = chartInstance.chart.getElementsAtEventForMode(event, "nearest", { intersect: true }, true);
        if (points.length === 0) {
          console.log("차트 내부 빈 공간 클릭됨!");
          alert("차트 내부 빈 공간 클릭!");
        }
      });
    }
  }
}
