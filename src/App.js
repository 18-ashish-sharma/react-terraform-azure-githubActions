import React from "react";
import { useState, useEffect } from "react";
import { Card, Col, Row } from "react-bootstrap";

const HomePage = () => {
  const [toonInfo, setToonInfo] = useState({});

  useEffect(() => {
    const fetchData = async () => {
      const result = await fetch(
        `https://api4all.azurewebsites.net/api/people/`
      );
      const body = await result.json();
      setToonInfo(body);
    };
    fetchData();
  }, []);

  const renderCard = (card, index) => {
    return (
      <Col>
        <Card style={{ width: "50%" }} key={index}>
          <Card.Img variant="top" src={card.pictureUrl} />
          <Card.Body>
            <Card.Title style={{ fontSize: "12px" }}>
              {card.firstName} {card.lastName}
            </Card.Title>
            <Card.Text style={{ fontSize: "10px" }}>
              {card.occupation}
            </Card.Text>
          </Card.Body>
        </Card>
      </Col>
    );
  };

  return (
    <React.Fragment>
      <Row xs={1} sm={2} md={3} lg={5} className="g-4">
        {Array.from(toonInfo).map((item, key) => renderCard(item, key))}
      </Row>
    </React.Fragment>
  );
};

export default HomePage;