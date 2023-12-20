import { EventCreated } from '../generated/EventVotingNFT/EventVotingNFT'
import { EventVotingNFT } from '../generated/schema'

export function handleEventCreated(event: EventCreated): void {
  let entity = new EventVotingNFT(event.params.eventId.toHex())

  entity.who = event.params.who
  entity.what = event.params.what
  entity.when = event.params.when
  entity.creator = event.params.creator

  entity.save()
}
