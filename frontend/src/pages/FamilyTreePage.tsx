import { useEffect, useRef, useState } from 'react'
import * as d3 from 'd3'

const FamilyTreePage: React.FC = () => {
  const svgRef = useRef<SVGSVGElement>(null)
  const [zoom, setZoom] = useState(1)

  // Sample data - in real app, fetch from API
  const treeData = {
    name: "John Simanjuntak",
    gender: "L",
    children: [
      {
        name: "Jane Simanjuntak",
        gender: "P",
        spouse: { name: "Bob Marbun", gender: "L" },
        children: [
          { name: "Alice Marbun", gender: "P" },
          { name: "Charlie Marbun", gender: "L" }
        ]
      },
      {
        name: "Mike Simanjuntak",
        gender: "L",
        children: [
          { name: "Emma Simanjuntak", gender: "P" }
        ]
      }
    ]
  }

  useEffect(() => {
    if (!svgRef.current) return

    const svg = d3.select(svgRef.current)
    svg.selectAll("*").remove()

    const width = 800
    const height = 600
    const margin = { top: 50, right: 50, bottom: 50, left: 50 }

    const root = d3.hierarchy(treeData)
    const treeLayout = d3.tree().size([height - margin.top - margin.bottom, width - margin.left - margin.right])
    treeLayout(root)

    const g = svg.append("g")
      .attr("transform", `translate(${margin.left},${margin.top})`)

    // Links
    g.selectAll(".link")
      .data(root.links())
      .enter()
      .append("path")
      .attr("class", "link")
      .attr("d", d3.linkHorizontal().x((d: any) => d.y).y((d: any) => d.x))
      .style("fill", "none")
      .style("stroke", "#94a3b8")
      .style("stroke-width", 2)

    // Nodes
    const node = g.selectAll(".node")
      .data(root.descendants())
      .enter()
      .append("g")
      .attr("class", "node")
      .attr("transform", (d: any) => `translate(${d.y},${d.x})`)

    node.append("circle")
      .attr("r", 20)
      .style("fill", (d: any) => d.data.gender === "L" ? "#3b82f6" : "#ec4899")
      .style("stroke", "#fff")
      .style("stroke-width", 2)

    node.append("text")
      .attr("dy", 35)
      .attr("text-anchor", "middle")
      .text((d: any) => d.data.name)
      .style("font-size", "12px")

    // Zoom
    svg.call(d3.zoom().on("zoom", (event) => {
      g.attr("transform", event.transform)
      setZoom(event.transform.k)
    }) as any)

  }, [treeData])

  return (
    <div className="space-y-4">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Family Tree</h1>
        <div className="flex space-x-2">
          <button className="px-4 py-2 border rounded hover:bg-gray-50">
            Zoom: {Math.round(zoom * 100)}%
          </button>
          <button className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
            Export
          </button>
        </div>
      </div>
      <div className="border rounded-lg overflow-hidden bg-white">
        <svg ref={svgRef} width={800} height={600} />
      </div>
    </div>
  )
}

export default FamilyTreePage
