import { useState } from "react";
import { NuiEvent } from "../hooks/NuiEvent";
import { nuicallback } from "../util/nuicallback";
import Fade from "../util/Fade";
import { debug } from "./debugdata";

const Radial = () => {
  const [visible, setVisible] = useState(false);
  const [options, setOptions] = useState(debug);
  const [hoveritem, setHoverItem] = useState(false);

  NuiEvent("setup:radial", (data) => {
    setVisible(data.visible);
    data.options && setOptions(data.options);
  });

  const radialitems = [];
  for (var i in options) {
    radialitems.push();
  }

  return (
    <>

        <div style={{display: visible ? 'flex' : 'none'}} className="radial-wrapper">
          <div className="radial-container">
            {options.map((data) => (
              <div
              onMouseEnter={() => {
                setHoverItem(data.slot - 1);
              }}
              
                onClick={() => {
                  nuicallback("useitem", data.slot)
                  setVisible(false)
                }}
                style={{
                  top:
                    (
                      50 +
                      35 *
                        Math.sin(
                          -0.5 * Math.PI -
                            2 * (1 / options.length) * (data.slot - 1) * Math.PI
                        )
                    ).toFixed(4) + "%",
                  left:
                    (
                      50 -
                      35 *
                        Math.cos(
                          -0.5 * Math.PI -
                            2 * (1 / options.length) * (data.slot - 1) * Math.PI
                        )
                    ).toFixed(4) + "%",
                  transform: `rotate(${(data.slot - 1) * 45}deg)`,
                }}
              >
                <img
                  style={{ transform: `rotate(-${(data.slot - 1) * 45}deg)` }}
                  src={data.imageurl}
                  alt=""
                />
              </div>
            ))}
          </div>

          <div className="item-info">
            {options[hoveritem] && (
              <>
                <img src={options[hoveritem].imageurl} alt="" />
                <div>{options[hoveritem].name}</div>
                <div>{options[hoveritem].count}x</div>
              </>
            )}
          </div>
        </div>
    </>
  );
};

export default Radial;
