const { runQuery } = require("./js/config");

async function viewPlayers() {
  return await runQuery(`SELECT * FROM Players`);
}

async function viewPlayerStats(id) {
  return await runQuery(`SELECT * FROM PlayersStats WHERE PlayerID = ${id}`);
}

async function addNewPlayer(
  firstName,
  lastName,
  nationality,
  date_of_birth,
  position,
  footed,
  active,
  agentID
) {
  const query = `INSERT INTO Players VALUES('${firstName}'','${lastName}','${nationality}','${date_of_birth}','${position}','${footed}', '${active}', '${agentID}')`;

  const result = await runQuery(query);
  if (result instanceof Error) throw new Error(result);
  return result;
}
