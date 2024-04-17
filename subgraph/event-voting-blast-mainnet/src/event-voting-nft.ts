import { EventCreated, Voted } from '../generated/EventVotingNFT/EventVotingNFT'
import { EventVotingNFT, Vote } from '../generated/schema'

export function handleEventCreated(event: EventCreated): void {
  let entity = new EventVotingNFT(event.params.eventId.toHex())

  entity.who = event.params.who
  entity.what = event.params.what
  entity.when = event.params.when
  entity.creator = event.params.creator
  entity.yes = 0
  entity.no = 0
  entity.status = 'CREATED'

  entity.save()
}

export function handleEventVoted(event: Voted): void {
  let nftId = event.params.eventId.toHex()
  let nftEntity = EventVotingNFT.load(nftId)
  if (nftEntity != null) {
    if (event.params.vote) {
      nftEntity.yes = nftEntity.yes + 1
    } else {
      nftEntity.no = nftEntity.no + 1
    }
    nftEntity.save()
  }

  let voteId = event.transaction.hash.toHex()
  let voteEntity = new Vote(voteId)
  voteEntity.eventVotingNFT = nftId
  voteEntity.eventVotingNFTId = nftId
  voteEntity.voter = event.params.voter
  voteEntity.voteYes = event.params.vote
  voteEntity.save()
}
